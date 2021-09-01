import 'package:flutter/material.dart';

import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/pages/home_page.dart';
import 'package:formvalidation/src/pages/login_page.dart';
import 'package:formvalidation/src/pages/produtcots_pague.dart';
import 'package:formvalidation/src/pages/registro%20usuario.dart';
import 'package:formvalidation/src/preferencias_usuario/preferences_user.dart';

void main() async {
  //las giguientes lineas son para usar preferencias
  //WidgetsFlutterBinding.ensureInitialized()
  WidgetsFlutterBinding.ensureInitialized();
  final pref = new PreferenciasUsuario();
  await pref.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pref = new PreferenciasUsuario();
    // print(pref.token); //imprime el tokken cuando se obtiene
    String rutainicial = 'login';
    if (pref.token != null) {
      rutainicial = 'home';
    }
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: rutainicial,
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPague(),
          'home': (BuildContext context) => HomePage(),
          'producto': (BuildContext context) => Productos_pague(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
