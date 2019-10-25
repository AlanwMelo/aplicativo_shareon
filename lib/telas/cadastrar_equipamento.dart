import 'package:aplicativo_shareon/utils/image_source_sheet.dart';
import 'package:aplicativo_shareon/utils/product_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {

  final ProductBloc _productBloc;


  ProductScreen() : _productBloc = ProductBloc();

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {

    final _fieldStyle = TextStyle(
      color: Colors.black,
      fontSize: 16
    );

    InputDecoration _buildDecoration(String label){
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black)
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Equipamento"),
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Text("Imagens",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 124,
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Icon(Icons.camera_enhance, color: Colors.white,),
                            color: Colors.indigo,
                          ),
                          onTap: (){
                            showModalBottomSheet(context: context,
                                builder: (context)=> ImageSourceSheet()
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            TextFormField(
              style: _fieldStyle,
              decoration: _buildDecoration("Titulo"),
              onSaved: (t){},
              validator: (t){},
            ),
            TextFormField(
              maxLines: 6,
              style: _fieldStyle,
              decoration: _buildDecoration("Descrição"),
              onSaved: (t){},
              validator: (t){},
            ),
            TextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              style: _fieldStyle,
              decoration: _buildDecoration("Preço"),
              onSaved: (t){},
              validator: (t){},
            ),
          ],
        ),
      ),
    );
  }
}
