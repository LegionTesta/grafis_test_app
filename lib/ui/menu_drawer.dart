
import 'package:flutter/material.dart';
import 'package:grafis_test_app/ui/client_screen.dart';
import 'package:grafis_test_app/ui/new_order_screen.dart';
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
              child: ListTile(
                title: Text("Menu"),
                leading: Icon(Icons.menu),
              ),
            ),
            ListTile(
              title: Text("Clientes"),
              leading: Icon(Icons.person),
              onTap: onClientsTap,
            ),
            ListTile(
              title: Text("Produtos"),
              leading: Icon(Icons.fastfood),
              onTap: onProductsTap,
            ),
            ListTile(
              title: Text("Novo pedido"),
              leading: Icon(Icons.add_shopping_cart),
              onTap: onNewOrdersTap,
            ),
            ListTile(
              title: Text("Pedidos"),
              leading: Icon(Icons.shopping_cart),
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

  void onNewOrdersTap(){
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewOrderScreen()));
  }

  void onOrdersTap(){}
}
