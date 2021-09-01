//aqui podemos definir si un dato es un numero o tal
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final n = num.tryParse(s); //si se puede parcear a  nuemro
  return (n == null) ? false : true; //si n=null else = true
}

//mensaje de aler dialog
mostraralerta(BuildContext context, String mensaje) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(' informacion incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('ok'))
          ],
        );
      });
}
