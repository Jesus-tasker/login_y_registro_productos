import 'dart:convert';

import 'package:formvalidation/src/preferencias_usuario/preferences_user.dart';
import 'package:http/http.dart' as http;

class Ususario_Provider {
  final String _firebasetokken =
      'AIzaSyAV-MwYJgCM85vFoPnelGA3GVhv_5g7c1k'; //setting/firebase/clave api web

  final _pref_shared =
      new PreferenciasUsuario(); //instancia para shared preferences

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authdata = {
      'email': email,
      'password': password,
      'return_Secure_Tokken': true
    };
    //aqui la diferencia es el ul donde nos dirigimos para validar el usuario
    final Uri url_endpoint_auth = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebasetokken');

    final respuesta =
        await http.post(url_endpoint_auth, body: json.encode(authdata));

    Map<String, dynamic> decodeRespuesta = json.decode(respuesta.body);
    // print(decodeRespuesta); //aqui meustra que creamos la autenticacion correctamente
    if (decodeRespuesta.containsKey('idToken')) {
      //salvar el tokken en shared preferences
      _pref_shared.token = decodeRespuesta['idToken'];
      print(decodeRespuesta);
      return {
        'ok': true,
        'token': decodeRespuesta['idToken']
      }; //ruta json con el idtokken
    } else {
      //error ej email ya usado
      return {
        'ok': false,
        'mensaje': decodeRespuesta['error']['message']
      }; //ruta con el error json
      //

    }
  }

  Future<Map<String, dynamic>> nuevousuario(
      String email, String password) async {
    final authdata = {
      'email': email,
      'password': password,
      'return_Secure_Token': true
    };

    final Uri url_endpoint_auth = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebasetokken');

    final respuesta =
        await http.post(url_endpoint_auth, body: json.encode(authdata));

    Map<String, dynamic> decodeRespuesta = json.decode(respuesta.body);
    // print(decodeRespuesta); //aqui meustra que creamos la autenticacion correctamente

    if (decodeRespuesta.containsKey('idToken')) {
//sobreescribir el tokken en sharen preferences
      _pref_shared.token = decodeRespuesta['idToken'];

      return {
        'ok': true,
        'mensaje': decodeRespuesta['idToken']
      }; //ruta json con el idtokken
    } else {
      //error ej email ya usado
      return {
        'ok': false,
        'mensaje': decodeRespuesta['error']['message']
      }; //ruta con el error json
      //

    }
  }
}
