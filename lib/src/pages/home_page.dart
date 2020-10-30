import 'package:flutter/material.dart';

import 'package:firebase_crud_ap/src/models/product_model.dart';
import 'package:firebase_crud_ap/src/providers/product_provider.dart';
import 'package:firebase_crud_ap/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  final productProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: _createList(),
      floatingActionButton: _createButton(context),
    );
  }

  _createButton(context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }

  _createList() {
    return FutureBuilder(
        future: productProvider.uploadProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, i) => _createItem(context, products[i]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _createItem(BuildContext context, ProductModel product) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direction) {
          productProvider.deleteProduct(product.id);
        },
        child: Card(
            child: Column(
          children: [
            (product.urlPhoto == null)
                ? Image(image: AssetImage('assets/no-image.png'))
                : FadeInImage(
                    image: NetworkImage(product.urlPhoto),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: product),
            ),
          ],
        )));
  }
}
