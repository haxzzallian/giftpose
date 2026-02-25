import 'package:dio/dio.dart';
import 'package:giftpose_app/common/data-models/server-rersponse.model.dart';
import 'package:giftpose_app/common/services/base-http.service.dart';

class ProductService extends BaseService {
  final Dio dioClient = Dio();

  Future<ServerResponse> fetchProducts({int page = 1, int limit = 30}) async {
    return await dioRequestWrapper(
      () => dioClient.get(
        "https://dummyjson.com/products",
        queryParameters: {
          "limit": limit,
          "skip": (page - 1) * limit,
        },
      ),
      "Fetch Products",
    );
  }

  Future<ServerResponse> fetchCategories() async {
    return await dioRequestWrapper(
      () => dioClient.get("https://dummyjson.com/products/categories"),
      "Fetch Categories",
    );
  }

  Future<ServerResponse> fetchProductsByCategory(String slug) async {
    return await dioRequestWrapper(
      () => dioClient.get(
        "https://dummyjson.com/products/category/$slug",
      ),
      "Fetch Products By Category",
    );
  }

  Future<ServerResponse> fetchProductById(int id) async {
    return await dioRequestWrapper(
      () => dioClient.get("https://dummyjson.com/products/$id"),
      "Fetch Product By Id",
    );
  }
}
