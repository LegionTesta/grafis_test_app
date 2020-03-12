

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grafis_test_app/bloc/product/product_register_bloc.dart';

class ProductRegisterScreen extends StatefulWidget {
  @override
  _ProductRegisterScreenState createState() => _ProductRegisterScreenState();
}

class _ProductRegisterScreenState extends State<ProductRegisterScreen> {

  ProductRegisterBloc _productRegisterBloc;

  @override
  void initState() {
    _productRegisterBloc = ProductRegisterBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo producte"),
        ),
        body: Container(
          child: BlocBuilder(
              bloc: _productRegisterBloc,
              builder: (BuildContext context, ProductRegisterBlocState state){
                if(state is InitialProductRegisterBlocState){
                  return buildRegisterProductForm(context);
                }
                if(state is RegisteringProduct){
                  return buildAwaitingResponse(context);
                }
                if(state is ProductRegistered){
                  return buildProductRegistered(context);
                }
                if(state is ProductNotRegistered){
                  return buildProductNotRegistered(context);
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  Widget buildRegisterProductForm(BuildContext context){

  }

  Widget buildAwaitingResponse(BuildContext context){

  }

  Widget buildProductRegistered(BuildContext context){

  }

  Widget buildProductNotRegistered(BuildContext context){

  }
}
