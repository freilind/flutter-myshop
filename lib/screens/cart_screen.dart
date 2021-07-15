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
            Chip(
              label: Text('\$${_cartProvider.totalAmount.toStringAsFixed(2)}', 
              style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6?.color)),
              backgroundColor: Theme.of(context).primaryColor),
            OrderButton(cartProvider: _cartProvider)
          ]))),
        SizedBox(height: 10),
        Expanded(child: ListView.builder(
          itemBuilder: (ctx, index) => CartItem(
              id: _cartProvider.items.values.toList()[index].id,
              productId: _cartProvider.items.keys.toList()[index],
              price: _cartProvider.items.values.toList()[index].price,
              quantity: _cartProvider.items.values.toList()[index].quantity,
              title: _cartProvider.items.values.toList()[index].title),
              itemCount: _cartProvider.items.length))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required CartProvider cartProvider,
  }) : _cartProvider = cartProvider, super(key: key);

  final CartProvider _cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).primaryColor)),
      onPressed: (widget._cartProvider.totalAmount <= 0 ) || _isLoading 
        ? null 
        : () async {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<OrdersProvider>(context, listen: false).addOrder(
            widget._cartProvider.items.values.toList(),
            widget._cartProvider.totalAmount);
            setState(() {
              _isLoading = false;
            });
            widget._cartProvider.clear();
        },
      );
  }
}