import 'package:get_it/get_it.dart';
import 'package:giftpose_app/modules/products/service/product-service.dart';
import 'package:giftpose_app/modules/products/view-model/products-view-model.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => ProductService());
  locator.registerLazySingleton(() => ProductViewModel());
}
