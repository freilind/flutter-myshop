import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/product.dart';

class CartItem extends StatelessWidget {
  final String id;
  final Product product;
  final int quantity;
  final String title;

  const CartItem({Key? key,
    required this.id,
    required this.product,
    required this.quantity,
    required this.title, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4)
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          Provider.of<CartProvider>(context, listen: false).removeItem(product.id);
        },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: Text('\$${product.price}')),
              ),),
        title: Text(title),
        subtitle: Text('Total \$${(product.price * quantity)}'),
        trailing: Text('$quantity x'),),)
      ),
    );
  }
}