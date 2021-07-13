import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/orders_provider.dart';
import 'package:store_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(
        children: <Widget>[
        Card(
        margin: EdgeInsets.all(15),
        child: Padding(padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          Text('Total', style: TextStyle(fontSize: 20)),
          Spacer(),
          Chip(label: Text('\$${_cartProvider.totalAmount.toStringAsFixed(2)}', 
          style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6?.color)),
          backgroundColor: Theme.of(context).primaryColor),
          TextButton(
            onPressed: () {
              Provider.of<OrdersProvider>(context, listen: false).addOrder(
                _cartProvider.items.values.toList(),
                _cartProvider.totalAmount);
                _cartProvider.clear();
            },
            child: Text('Order now'),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor)),)
        ]))),
        SizedBox(height: 10),
        Expanded(child: ListView.builder(
          itemBuilder: (context, index) => CartItem(
              id: _cartProvider.items.values.toList()[index].id,
              product: _cartProvider.items.values.toList()[index].product,
              quantity: _cartProvider.items.values.toList()[index].quantity,
              title: _cartProvider.items.values.toList()[index].product.title),
              itemCount: _cartProvider.items.length))
      ]),
    );
  }
}