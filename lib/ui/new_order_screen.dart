
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_bloc.dart';
import 'package:grafis_test_app/bloc/order/order_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/order.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/ui/menu_drawer.dart';

class NewOrderScreen extends StatefulWidget {
  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {

  ClientBloc _clientBloc;
  ProductBloc _productBloc;
  OrderBloc _orderBloc;

  List<Product> filteredProducts = List();
  List<Product> products = List();
  List<Client> filteredClients = List();
  List<Client> clients = List();

  final _amountFormKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();

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
                    filteredClients = state.clients;
                    clients = state.clients;
                    return buildClientsList(context);
                  }
                  if(state is ClientsFiltered){
                    filteredClients = state.clients;
                    return buildClientsList(context);
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
                      filteredProducts = state.products;
                      products = state.products;
                      return buildProductsList(context);
                    }
                    if(state is ProductsFiltered){
                      filteredProducts = state.products;
                      return buildProductsList(context);
                    }
                    return Container();
                  }
              ),
              BlocBuilder(
                bloc: _orderBloc,
                  builder: (BuildContext context, OrderBlocState state){
                    if(state is InitialOrderBlocState){
                      return buildOrder(context, null);
                    }
                    if(state is OrderUpdated){
                      return buildOrder(context, state.completeOrder);
                    }
                    if(state is SelectingAmount){
                      return buildOrder(context, state.completeOrder);
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

  Widget buildOrder(BuildContext context, CompleteOrder completeOrder){
    return Expanded(
      child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text("Pedido"),
                ),
                Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: completeOrder != null ? completeOrder.client != null ?
                              Text("Cliente: ${completeOrder.client.name}") : Text("Cliente: ") : Text("Cliente: "),
                        ),
                        ListTile(
                          title: completeOrder != null? completeOrder.currentProduct != null ?
                              Text("Produto: ${completeOrder.currentProduct.desc}") : Text("Produto: ") : Text("Produto: "),
                        ),
                        ListTile(
                          title: Form(
                            key: _amountFormKey,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 100,
                                  child: Text("Quantidade:"),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: amountController,
                                    validator: (value){
                                      if(completeOrder != null){
                                        if(completeOrder.client == null)
                                          return "Selecione um Cliente.";
                                        if(completeOrder.currentProduct == null)
                                          return "Selecione um Produto.";
                                      } else {
                                        return "Selecione um Cliente";
                                      }
                                      if(value.isEmpty)
                                        return "Campo Quantidade vazio.";
                                      try{
                                        if(double.parse(value) <= 0)
                                          return "Valor inserido menor ou igual a 0.";
                                        return null;
                                      } catch(e){
                                        return "Valor inserido inválido.";
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 93,
                                  child: RaisedButton(
                                    onPressed: (){
                                      if(_amountFormKey.currentState.validate()){
                                        _orderBloc.add(AddProduct(
                                          product: completeOrder.currentProduct,
                                          amount: double.parse(amountController.text)
                                        ));
                                        amountController.text = "";
                                      }
                                    },
                                    child: Text("Adicionar"),
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                        buildOrderProductsList(context, completeOrder)
                      ],
                    ),
                  )
                ),
              ],
            ),
          )
      ),
    );
  }

  Widget buildOrderProductsList(BuildContext context, CompleteOrder completeOrder){
    if(completeOrder != null)
      if(completeOrder.products != null){
        var products = completeOrder.products;
        return Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, index){
                      return ListTile(
                        title: Text(
                            "${products[index].amount}x ${products[index].product.desc}"
                        ),
                        subtitle: Text("R\$ ${products[index].product.price.toStringAsFixed(2)}"),
                        trailing: RaisedButton(
                          onPressed: (){
                          },
                          child: Text("TODO: Remove"),
                        ),
                      );
                    }
                ),
              ],
            )
        );
      }
    return Container();
  }

  Widget buildClientsList(BuildContext context){
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Procure por Nome ou Email..."
              ),
              onChanged: (value){
                _clientBloc.add(FilterClients(clients: clients, filter: value));
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                  itemCount: filteredClients.length,
                  itemBuilder: (BuildContext context, index){
                    return Card(
                      child: ListTile(
                        title: Text(filteredClients[index].name),
                        subtitle: Text(filteredClients[index].email),
                        trailing: RaisedButton(
                          onPressed: (){
                            _orderBloc.add(SelectClient(client: filteredClients[index]));
                          },
                          child: Text("Selecionar"),
                        ),
                      ),
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildProductsList(BuildContext context){
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Procure por Descrição..."
              ),
              onChanged: (value){
                _productBloc.add(FilterProducts(products: products, filter: value));
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, index){
                    return Card(
                      child: ListTile(
                        title: Text(filteredProducts[index].desc),
                        subtitle: Text("R\$ ${filteredProducts[index].price.toStringAsFixed(2)}"),
                        trailing: RaisedButton(
                          onPressed: (){
                            _orderBloc.add(SelectProduct(product: filteredProducts[index]));
                          },
                          child: Text("Selecionar"),
                        ),
                      ),
                    );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}