import 'package:giftpose_app/common/data-models/server-rersponse.model.dart';
import 'package:giftpose_app/common/view-models/base-view-model.dart';
import 'package:giftpose_app/constant/locator.dart';
import 'package:giftpose_app/modules/products/data-model/product-category.model.dart';

import 'package:giftpose_app/modules/products/data-model/product.model.dart';
import 'package:giftpose_app/modules/products/service/product-service.dart';

import 'package:provider/provider.dart';

class ProductViewModel extends BaseViewModel {
  final ProductService _productService = locator<ProductService>();

  // Products
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> _paginatedProducts = [];

  // Pagination state
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int _totalProducts = 0;

  static const int _pageSize = 10;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  List<Product> get paginatedProducts => _paginatedProducts;

  // Categories
  List<ProductCategory> _categories = [];
  List<ProductCategory> get categories => _categories;

  // Selected category — null means "All"
  ProductCategory? _selectedCategory;
  ProductCategory? get selectedCategory => _selectedCategory;

  // Derived lists — use filtered when a category is selected
  List<Product> get _activeProducts =>
      _filteredProducts.isNotEmpty || _selectedCategory != null
          ? _filteredProducts
          : _allProducts;

  List<Product> get newArrivals => _activeProducts.take(6).toList();
  List<Product> get trendingProducts =>
      _activeProducts.skip(6).take(6).toList();
  List<Product> get promotions =>
      _activeProducts.where((p) => p.discountPercentage > 10).take(6).toList();
  List<Product> get hotDeals => _activeProducts
      .where((p) => p.discountPercentage > 5)
      .skip(3)
      .take(6)
      .toList();

  Product? _selectedProduct;
  Product? get selectedProduct => _selectedProduct;
  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  List<Product> get filteredProducts =>
      _selectedCategory != null ? _filteredProducts : _allProducts;

  // Fetch all products
  Future<bool> fetchProducts({bool refresh = false}) async {
    if (_allProducts.isNotEmpty && !refresh) return true;

    return performAPIAction(
      action: () async {
        ServerResponse response = await _productService.fetchProducts();
        if (response.status) {
          final data = response.data as Map<String, dynamic>;
          final List<dynamic> productList = data['products'] ?? [];
          _allProducts = productList.map((p) => Product.fromJson(p)).toList();
          _filteredProducts = [];
          notifyListeners();
        }
        return response;
      },
      showSuccessToast: false,
      showErrorToast: true,
    );
  }

  // Initial paginated fetch — call once on homepage init
  Future<bool> fetchPaginatedProducts({bool refresh = false}) async {
    if (_paginatedProducts.isNotEmpty && !refresh) return true;

    _currentPage = 1;
    _hasMore = true;
    _paginatedProducts = [];

    return performAPIAction(
      action: () async {
        ServerResponse response = await _productService.fetchProducts(
          page: _currentPage,
          limit: _pageSize,
        );
        if (response.status) {
          final data = response.data as Map<String, dynamic>;
          final List<dynamic> productList = data['products'] ?? [];
          _totalProducts = data['total'] ?? 0;
          _paginatedProducts =
              productList.map((p) => Product.fromJson(p)).toList();
          _hasMore = _paginatedProducts.length < _totalProducts;
          notifyListeners();
        }
        return response;
      },
      showSuccessToast: false,
      showErrorToast: true,
    );
  }

  // Load next page — called when user scrolls to bottom
  Future<void> loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final response = await _productService.fetchProducts(
        page: _currentPage,
        limit: _pageSize,
      );

      if (response.status) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> productList = data['products'] ?? [];
        final newProducts =
            productList.map((p) => Product.fromJson(p)).toList();
        _paginatedProducts.addAll(newProducts);
        _hasMore = _paginatedProducts.length < _totalProducts;
      }
    } catch (e) {
      _currentPage--; // revert on failure
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Fetch categories
  Future<bool> fetchCategories({bool refresh = false}) async {
    if (_categories.isNotEmpty && !refresh) return true;

    return performAPIAction(
      action: () async {
        ServerResponse response = await _productService.fetchCategories();
        if (response.status) {
          final List<dynamic> data = response.data as List<dynamic>;
          _categories = data.map((c) => ProductCategory.fromJson(c)).toList();
          notifyListeners();
        }
        return response;
      },
      showSuccessToast: false,
      showErrorToast: true,
    );
  }

  // Filter by category
  Future<void> selectCategory(ProductCategory? category) async {
    _selectedCategory = category;
    notifyListeners();

    if (category == null) {
      // "All" selected — clear filter
      _filteredProducts = [];
      notifyListeners();
      return;
    }

    await performAPIAction(
      action: () async {
        ServerResponse response =
            await _productService.fetchProductsByCategory(category.slug);
        if (response.status) {
          final data = response.data as Map<String, dynamic>;
          final List<dynamic> productList = data['products'] ?? [];
          _filteredProducts =
              productList.map((p) => Product.fromJson(p)).toList();
          notifyListeners();
        }
        return response;
      },
      showSuccessToast: false,
      showErrorToast: true,
    );
  }

  Future<bool> fetchProductById(int id) async {
    _isLoadingDetail = true;
    _selectedProduct = null;
    notifyListeners();

    return performAPIAction(
      action: () async {
        ServerResponse response = await _productService.fetchProductById(id);
        if (response.status) {
          final data = response.data as Map<String, dynamic>;
          _selectedProduct = Product.fromJson(data);
          _isLoadingDetail = false;
          notifyListeners();
        }
        return response;
      },
      showSuccessToast: false,
      showErrorToast: true,
    );
  }
}
