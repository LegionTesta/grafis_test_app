
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_register_bloc.dart';
import 'package:grafis_test_app/core/product.dart';
import 'package:grafis_test_app/ui/menu_drawer.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  ProductBloc _productBloc;
  ProductRegisterBloc _productRegisterBloc;

  final _formKey = GlobalKey<FormState>();

  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<Product> filteredProducts = List();
  List<Product> products = List();

  @override
  void initState() {
    _productBloc = ProductBloc();
    _productBloc.add(ReloadProducts());
    _productRegisterBloc = ProductRegisterBloc();
    _productRegisterBloc.listen((state) {
      if(state is RegisteringProduct){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("Carregando..."),
              );
            }
        );
      }
      if(state is ProductRegistered){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("O produto foi registrado!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
        );
        descController.text = "";
        priceController.text = "";
        _productBloc.add(ReloadProducts());
      }
      if(state is ProductNotRegistered){
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text("O produto não foi registrado!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Produtos"),
        ),
        drawer: MenuDrawer(),
        body: Container(
          child: Row(
            children: <Widget>[
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
                  bloc: _productRegisterBloc,
                  builder: (BuildContext context, ProductRegisterBlocState state){
                    if(state is InitialProductRegisterBlocState){
                      return buildRegisterProductForm(context);
                    }
                    return Container();
                  }
              ),
            ],
          ),
        ),
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

  Widget buildRegisterProductForm(BuildContext context){
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: descController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: "Insira a descrição do produto",
                      labelText: "Descrição"
                  ),
                  validator: (value){
                    if(value.isEmpty)
                      return "Campo Descrição vazio.";
                    return null;
                  },
                ),
              ),
              Container(
                child: TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                      icon: Icon(Icons.attach_money),
                      hintText: "Insira o preço do produto",
                      labelText: "Preço"
                  ),
                  validator: (value){
                    if(value.isEmpty)
                      return "Campo Preço vazio.";
                    try{
                      if(double.parse(value) < 0)
                        return "Valor inserido menor que 0.";
                      return null;
                    } catch(e){
                      return "Valor inserido inválido.";
                    }
                  },
                ),
              ),
              Container(
                child: RaisedButton(
                  onPressed: (){
                    if(_formKey.currentState.validate()){
                      _productRegisterBloc.add(RegisterProduct(product: Product(
                          desc: descController.text,
                          price: double.parse(priceController.text)
                      )));
                    }
                  },
                  child: Text("Cadastrar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
