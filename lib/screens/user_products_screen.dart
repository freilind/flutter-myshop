import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/products_provider.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: '');
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: _productsProvider.items.length,
            itemBuilder: (_, i) => Column(
                  children: [
                    UserProductItem(
                      id: _productsProvider.items[i].id,
                      title: _productsProvider.items[i].title,
                      imageUrl: _productsProvider.items[i].imageUrl,
                    ),
                    Divider(),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
