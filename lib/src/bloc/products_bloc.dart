import 'dart:async';
import 'dart:io';

import 'package:crud_firebase_bloc/src/models/product_model.dart';
import 'package:crud_firebase_bloc/src/providers/product_provider.dart';

class ProductsBloc {
  /* 
   * Stream Controllers
  */

  final _productsStreamController = new StreamController<List<ProductModel>>();

  final _uploadingStreamController = new StreamController<bool>();

  final _productProvider = ProductsProvider();

  /* 
   * Getter: stream and sink
  */

  Stream<List<ProductModel>> get productsOutputStream =>
      _productsStreamController.stream;
  StreamSink<List<ProductModel>> get productsInputSink =>
      _productsStreamController.sink;

  Stream<bool> get uplodingStream => _uploadingStreamController.stream;
  StreamSink<bool> get uplodingSink => _uploadingStreamController.sink;

  /* 
   * Methods
  */
  void getProducts() async {
    final products = await _productProvider.getProducts();
    _productsStreamController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _uploadingStreamController.sink.add(true);
    await _productProvider.createProduct(product);

    _uploadingStreamController.sink.add(false);
    getProducts();
  }

  Future<String> uploadPhoto(File file) async {
    _uploadingStreamController.sink.add(true);
    final photoUrl = await _productProvider.uploadImagen(file);

    _uploadingStreamController.sink.add(false);

    return photoUrl;
  }

  void editProduct(ProductModel product) async {
    _uploadingStreamController.sink.add(true);
    await _productProvider.editProduct(product);
    _uploadingStreamController.sink.add(false);
    getProducts();
  }

  void deleteProduct(String id) async {
    await _productProvider.deleteProduct(id);
  }

  /* 
   * Disposing
  */

  dispose() {
    _productsStreamController?.close();
    _uploadingStreamController?.close();
  }
}
