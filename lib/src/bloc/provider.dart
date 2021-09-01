import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/productos_block.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  ///provider es un wiget que con claves puede almacenar informacion y ubicarla usando patron block

  final loginBloc = new LoginBloc(); //login block
  final _productoblock = new ProductosBlock(); //productos block

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override //cone sto buscamos la ingormacion
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    //busca algo que se llame provider y tratao como provider eso es lo que dice
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .loginBloc;
  }

//pocudto
//home y donde agregamos el producto
  static ProductosBlock product_block(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._productoblock;
  }
}
