import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/widgets/app_drawer.dart';

import '../providers/orders_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
