
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_bloc.dart';
import 'package:grafis_test_app/bloc/order/order_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/ui/menu_drawer.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  ClientBloc _clientBloc;
  ProductBloc _productBloc;
  OrderBloc _orderBloc;


  @override
  void initState() {
    _clientBloc = ClientBloc();
    _productBloc = ProductBloc();
    _orderBloc = OrderBloc();
    _clientBloc.add(ReloadClients());
    _productBloc.add(ReloadProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pedidos"),
        ),
        drawer: MenuDrawer(),
        body: Container(
          child: Row(
            children: <Widget>[
              BlocBuilder(
                bloc: _clientBloc,
                builder: (BuildContext context, ClientBlocState state){
                  if(state is LoadingClients){
                    return Center(
                      child: Text("Carregando clientes..."),
                    );
                  }
                  if(state is ClientsLoaded){
                    return buildClientsList(context, state.clients);
                  }
                  return Container();
                }
              ),
              BlocBuilder(
                bloc: _productBloc,
                  builder: (BuildContext context, ProductBlocState state){
                    if(state is LoadingProducts){
                      return Center(
                        child: Text("Carregando produtos..."),
                      );
                    }
                    if(state is ProductsLoaded){
                      return buildProductsList(context, state.products);
                    }
                    return Container();
                  }
              ),
              BlocBuilder(
                bloc: _orderBloc,
                  builder: (BuildContext context, OrderBlocState state){
                    if(state is InitialOrderBlocState){
                      return Container();
                    }
                    return Container();
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClientsList(BuildContext context, List<Client> clients){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Clientes"),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: clients.length,
                itemBuilder: (BuildContext context, index){
                  return Card(
                    child: ListTile(
                      title: Text(clients[index].name),
                      subtitle: Text(clients[index].email),
                    ),
                  );
                }
            ),
          ],
        )
      ),
    );
  }

  Widget buildProductsList(BuildContext context, List<Product> products){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (BuildContext context, index){
              return Card(
                child: ListTile(
                  title: Text(products[index].desc),
                  subtitle: Text("R\$ ${products[index].price.toStringAsFixed(2)}"),
                ),
              );
            }
        ),
      ),
    );
  }
}
