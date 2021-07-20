import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/product.dart';
import 'package:store_app/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _product = ModalRoute.of(context)?.settings.arguments as Product;
    final _productsProvider = Provider.of<ProductsProvider>(context, listen: false)
        .findById(_product.id);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_productsProvider.title),
              background: Hero(
                tag: _productsProvider.id,
                child: Image.network(
                    _productsProvider.imageUrl,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate ([
              SizedBox(height: 10),
              Text('\$${_productsProvider.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20
                ),
                textAlign: TextAlign.center),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(_productsProvider.description,
                  textAlign: TextAlign.center,
                  softWrap: true,),
              ),
              SizedBox(height: 800)
            ]))
        ]
        ),
      );
  }
}
