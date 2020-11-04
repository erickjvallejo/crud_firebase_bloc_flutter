import 'dart:convert';
import 'dart:io';

import 'package:firebase_crud_ap/src/preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_crud_ap/src/models/product_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductsProvider {
  final String _url = 'https://flutter-varios-314d2.firebaseio.com';

  final _prefs = UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productModelToJson(product));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<List<ProductModel>> uploadProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return [];

    final List<ProductModel> products = new List();

    decodedData.forEach((firstProperty, product) {
      final productTemp = ProductModel.fromJson(product);
      productTemp.id = firstProperty;

      products.add(productTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productModelToJson(product));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<String> uploadImagen(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ddscbkbes/image/upload?upload_preset=wt8ahimz');

    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something is bad');
      print(resp.body);

      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }
}
