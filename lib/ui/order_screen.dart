

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/order/order_bloc.dart';
import 'package:grafis_test_app/core/order.dart';
import 'package:grafis_test_app/ui/menu_drawer.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  OrderBloc _orderBloc;

  List<CompleteOrder> orders = List();
  List<CompleteOrder> filteredOrders = List();

  @override
  void initState() {
    _orderBloc = OrderBloc();
    _orderBloc.add(LoadOrders());
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
          child: BlocBuilder(
            bloc: _orderBloc,
            builder: (BuildContext context, OrderBlocState state){
              if(state is LoadingOrders){
                return Text("Carregando pedidos...");
              }
              if(state is OrdersLoaded){
                orders = state.orders;
                filteredOrders = state.orders;
                return buildOrdersList(context);
              }
              if(state is OrdersFiltered){
                filteredOrders = state.orders;
                return buildOrdersList(context);
              }
              if(state is OrdersNotLoaded){
                return Text(state.msg);
              }
              if(state is InitialOrderBlocState){
                return Text("bb");
              }
              return Text(state.toString());
            },
          ),
        ),
      ),
    );
  }

  Widget buildOrdersList(BuildContext context){
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Procure por Nome, Email, Descrição, Data..."
            ),
            onChanged: (value){
              _orderBloc.add(FilterOrders(orders: orders, filter: value));
            },
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: ListTile(
                                title: Text(filteredOrders[index].client.name),
                                subtitle: Text(filteredOrders[index].client.email),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredOrders[index].products.length,
                              itemBuilder: (BuildContext context, int idx){
                                return ListTile(
                                  title: Text("${filteredOrders[index].products[idx].amount}x "
                                      "${filteredOrders[index].products[idx].product.desc}"),
                                  subtitle: Text("R\$ ${filteredOrders[index].products[idx].product.price.toStringAsFixed(2)}"),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text("Valor Total: R\$${filteredOrders[index].totalValue.toStringAsFixed(2)}"),
                              subtitle: Text("R\$${filteredOrders[index].value.toStringAsFixed(2)} - "
                                  "R\$${filteredOrders[index].discount.toStringAsFixed(2)}"),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text("${filteredOrders[index].date.day}/"
                                  "${filteredOrders[index].date.month}/"
                                  "${filteredOrders[index].date.year}"),
                              subtitle: Text("${filteredOrders[index].date.hour}:"
                                  "${filteredOrders[index].date.minute}"),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      )
                    ],
                  )
                );
              },
            )
          ),
        )
      ],
    );
  }
}
