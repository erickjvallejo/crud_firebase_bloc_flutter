import 'dart:io';

import 'package:crud_firebase_bloc/src/models/product_model.dart';
import 'package:crud_firebase_bloc/src/providers/product_provider.dart';
import 'package:rxdart/subjects.dart';

class ProductsBloc {
  /* 
   * Controllers
  */

  final _productsController = new BehaviorSubject<List<ProductModel>>();

  final _uploadingController = new BehaviorSubject<bool>();

  final _productProvider = ProductsProvider();

  /* 
   * Streams
  */

  Stream<List<ProductModel>> get productsStream => _productsController.stream;

  Stream<bool> get uplodingStream => _uploadingController.stream;

  /* 
   * Methods
  */

  void getProducts() async {
    final products = await _productProvider.getProducts();
    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _uploadingController.sink.add(true);
    await _productProvider.createProduct(product);
    _uploadingController.sink.add(false);
  }

  Future<String> uploadPhoto(File file) async {
    _uploadingController.sink.add(true);
    final photoUrl = await _productProvider.uploadImagen(file);

    _uploadingController.sink.add(false);

    return photoUrl;
  }

  void editProduct(ProductModel product) async {
    _uploadingController.sink.add(true);
    await _productProvider.editProduct(product);
    _uploadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productProvider.deleteProduct(id);
  }

  /* 
   * Disposing
  */

  dispose() {
    _productsController?.close();
    _uploadingController?.close();
  }
}
