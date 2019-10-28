import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:aplicativo_shareon/utils/images_widget.dart';
import 'package:aplicativo_shareon/utils/product_bloc.dart';
import 'package:aplicativo_shareon/validadores/product_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {

  ProductScreen();

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {

  final ProductBloc _productBloc;
  final _formularioKey = GlobalKey<FormState>();

  _ProductScreenState() : _productBloc = ProductBloc();

  @override
  Widget build(BuildContext context) {

    final _fieldstyle = TextStyle(
      color: Colors.black,
      fontSize: 16
    );

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
      );
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Equipamento"),
        centerTitle: true,
      ),
      body: Form(
        key: _formularioKey,
        child: StreamBuilder<Map>(
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                Text("imagens",
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 16
                ),
                ),
                ImagesWidget(
                  context: context,
                  initialValue: snapshot.data["images"],
                  onSaved: _productBloc.salvarImagens,
                  validator: validarImagens,


                ),
                TextFormField(
                  initialValue: snapshot.data["title"],
                  style: _fieldstyle,
                  decoration: _buildDecoration("Titulo"),
                  onSaved: _productBloc.salvarTitulo,
                  validator: validarIitulo,
                ),
                TextFormField(
                  initialValue: snapshot.data["description"],
                  style: _fieldstyle,
                  maxLines: 6,
                  decoration: _buildDecoration("Descrição"),
                  onSaved: _productBloc.salvarDescricao,
                  validator: validarDescricao,
                ),
                TextFormField(
                  initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                  style: _fieldstyle,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: _buildDecoration("Preço"),
                  onSaved: _productBloc.salvarPreco,
                  validator: validarPreco,
                ),
                SizedBox(height: 30,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text("Cadastrar",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      _formularioKey.currentState.validate();
                      if(_formularioKey.currentState.validate()){
                        _formularioKey.currentState.save();
                      }
                    },
                  ),
                ),
              ],
            );
          }
      ),
    ),
      );
  }
}
