
import 'package:flutter/material.dart';
import 'package:grafis_test_app/ui/client_screen.dart';
import 'package:grafis_test_app/ui/order_screen.dart';
import 'package:grafis_test_app/ui/product_screen.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Menu"),
            ),
            ListTile(
              title: Text("Produtos"),
              onTap: onProductsTap,
            ),
            ListTile(
              title: Text("Clientes"),
              onTap: onClientsTap,
            ),
            ListTile(
              title: Text("Pedidos"),
              onTap: onOrdersTap,
            )
          ],
        ),
      ),
    );
  }

  void onProductsTap(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductScreen()));
  }

  void onClientsTap(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClientScreen()));
  }

  void onOrdersTap(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen()));
  }
}
