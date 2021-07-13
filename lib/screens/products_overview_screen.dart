import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/screens/cart_screen.dart';
import 'package:store_app/widgets/app_drawer.dart';
import 'package:store_app/widgets/badge.dart';
import 'package:store_app/widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Myshop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions _selectValue) {
              setState(() {
                if (_selectValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show all'), value: FilterOptions.All),
            ],
          ),
          Consumer<CartProvider>(builder: (_, cart, ch) => 
            Badge(child: ch, value: cart.itemCount.toString()),
          child: IconButton(onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          }, icon: Icon(Icons.shopping_cart)),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(showFavorites: _showOnlyFavorites),
    );
  }
}
