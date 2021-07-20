import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/helpers/custom_route.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/providers/cart_provider.dart';
import 'package:store_app/providers/orders_provider.dart';
import 'package:store_app/providers/products_provider.dart';
import 'package:store_app/screens/auth_screen.dart';
import 'package:store_app/screens/cart_screen.dart';
import 'package:store_app/screens/edit_product_screen.dart';
import 'package:store_app/screens/orders_screen.dart';
import 'package:store_app/screens/product_detail_screen.dart';
import 'package:store_app/screens/products_overview_screen.dart';
import 'package:store_app/screens/splash_screen.dart';
import 'package:store_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()), 
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(),
          update: (ctx, auth, previousProductsProvider) {
            previousProductsProvider!.authToken = auth.token;
            previousProductsProvider.userIdd = auth.userId;
              return previousProductsProvider;
            },
        ), 
        ChangeNotifierProvider.value(value: CartProvider()),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(),
          update: (ctx, auth, previousOrdersProvider) {
            previousOrdersProvider!.authToken = auth.token;
            previousOrdersProvider.userIdd = auth.userId;
            previousOrdersProvider.orders = previousOrdersProvider.orders;
            return previousOrdersProvider;
          },
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder()
                })),
          home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
          routes: {
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen()
          },
        ))
    );
  }
}
