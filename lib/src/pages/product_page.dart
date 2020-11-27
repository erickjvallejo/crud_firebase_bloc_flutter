import 'dart:io';
import 'package:flutter/material.dart';

import 'package:crud_firebase_bloc/src/bloc/products_bloc.dart';
import 'package:crud_firebase_bloc/src/bloc/provider.dart';
import 'package:crud_firebase_bloc/src/models/product_model.dart';
import 'package:crud_firebase_bloc/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //final ProductsProvider productsProvider = new ProductsProvider();

  ProductsBloc productsBloc;
  ProductModel product = new ProductModel();
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectedPhoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showPhoto(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createName() {
    return TextFormField(
      onSaved: (value) => product.title = value,
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product',
      ),
      validator: (value) {
        if (value.length < 3) {
          return 'enter a product name';
        } else {
          return null;
        }
      },
    );
  }

  _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Price',
      ),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value))
          return null;
        else
          return 'Only numbers';
      },
    );
  }

  _createButton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.deepPurple,
        textColor: Colors.white,
        icon: Icon(Icons.save),
        onPressed: (_saving) ? null : _submit,
        label: Text('Save'));
  }

  _createAvailable() {
    return SwitchListTile(
      value: product.available,
      activeColor: Colors.deepPurple,
      title: Text('Available'),
      onChanged: (value) => setState(() {
        product.available = value;
      }),
    );
  }

  _submit() async {
    if (!formKey.currentState.validate()) return;

    // When the form is valid
    formKey.currentState.save();
    //Todo: revisar estos _saving
    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.urlPhoto = await productsBloc.uploadPhoto(photo);
    }

    if (product.id == null) {
      productsBloc.createProduct(product);
    } else {
      productsBloc.editProduct(product);
    }

/*
    setState(() {
      _saving = false;
    });
*/
    _showSnakbar('Record saved');

    Navigator.pop(context);
  }

  _showPhoto() {
    if (product.urlPhoto != null) {
      return FadeInImage(
        image: NetworkImage(product.urlPhoto),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (photo != null) {
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  void _showSnakbar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _selectedPhoto() async {
    _processImage(ImageSource.gallery);
  }

  _takePhoto() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource origen) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: origen);

    photo = File(pickedFile.path);

    if (photo != null) {
      product.urlPhoto = null;
    }
    setState(() {});
  }
}
