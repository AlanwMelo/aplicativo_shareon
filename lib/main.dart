import 'package:aplicativo_shareon/telas/tela_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/usuario_model.dart';
import 'package:google_map_location_picker/generated/i18n.dart' as location_picker;
import 'package:flutter_localizations/flutter_localizations.dart';

void main (){

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel <UserModel>(
      model: UserModel(),
      child: MaterialApp(
        localizationsDelegates: const [
          location_picker.S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('pt', ''),
          Locale('en', ''),
        ],
        title: "Share On",
        theme: ThemeData(
            primaryColor: Colors.indigo
        ),
        debugShowCheckedModeBanner: false,
        home: Login(),
      ),
    );
  }
}

