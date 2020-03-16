
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/client/client_bloc.dart';
import 'package:grafis_test_app/bloc/order/order_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_bloc.dart';
import 'package:grafis_test_app/core/client.dart';
import 'package:grafis_test_app/core/order.dart';
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

  Widget buildClientsList(BuildContext context, List<Client> clients){
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
                title: Text("Clientes"),
              ),
              Card(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: clients.length,
                    itemBuilder: (BuildContext context, index){
                      return ListTile(
                        title: Text(clients[index].name),
                        subtitle: Text(clients[index].email),
                        trailing: RaisedButton(
                          onPressed: (){
                            _orderBloc.add(SelectClient(client: clients[index]));
                          },
                          child: Text("Selecionar"),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget buildProductsList(BuildContext context, List<Product> products){
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
                title: Text("Produtos"),
              ),
              Card(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, index){
                      return ListTile(
                        title: Text(products[index].desc),
                        subtitle: Text("R\$ ${products[index].price.toStringAsFixed(2)}"),
                        trailing: RaisedButton(
                          onPressed: (){
                            _orderBloc.add(SelectProduct(product: products[index]));
                          },
                          child: Text("Selecionar"),
                        )
                      );
                    }
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

/*
Form(
                          key: _amountFormKey,
                          child: Row(
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  controller: amountController,
                                  decoration: InputDecoration(
                                      hintText: "Insira a quantidade do produto",
                                      labelText: "Quantidade"
                                  ),
                                  validator: (value){
                                    if(value.isEmpty)
                                      return "O campo Quantidade não pode estar vazio.";
                                    try{
                                      if(double.parse(value) < 0)
                                        return "O valor inserido não pode ser menor que 0.";
                                      return null;
                                    } catch(e){
                                      return "O valor inserido é inválido.";
                                    }
                                  },
                                ),
                              ),
                              RaisedButton(
                                onPressed: (){
                                  if(_amountFormKey.currentState.validate()){
                                    _orderBloc.add(AddProduct(
                                      product: products[index],
                                      amount: double.parse(amountController.text)
                                    ));
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text("Adicionar"),
                              ),
                            ],
                          ),
                        ),
 */
