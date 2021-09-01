//aqui haremos las interacciones directas con la based e datos
import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferences_user.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  //get put post delente:

  final String _url_bbdd =
      "https://flutterpruebas-92dcf-default-rtdb.firebaseio.com/";

  final _pref_user = new PreferenciasUsuario(); //shared preferences

  //  1.insertar un nuevo producto y pasamos solo  el modelo de datos
  // furute reemplaza el valor de algo hasta que obtenga algo
  Future<bool> crearproducto(Productomodel producto_model) async {
    //async
    //-creamos un Uri  al parcelear un url  "_url_bbdd/productos"
    final Uri url_productos = Uri.parse
        //  ('$_url_bbdd/productos.json?auth=${_pref_user.token}'); //auth
        ('$_url_bbdd/productos.json');
    //-http.post()
    final response1 = await http.post(url_productos,
        body: productomodelToJson(producto_model));

    //-productomodelToJson(producto_model)============== regresa el modelo json como string
    final decodedata = json.decode(response1.body); //respuesta
    print('Response body: ${response1.body}');
    print(' decode data =$decodedata');

    return true;
  }

  //get trear la lista de datos .
  Future<List<Productomodel>> cargar_productos() async {
    //-creamos un Uri  al parcelear un url  "_url_bbdd/productos"
    final Uri url_productos = Uri.parse('$_url_bbdd/productos.json'); //libre
    // '$_url_bbdd/productos.json?auth=${_pref_user.token}'); //auth

    final response1 = await http.get(url_productos); //obtenemos lista de nodods
    //1. lista de datos
    final List<Productomodel> productosList =
        new List(); //creamos una lista que recibira los datos

    //2.map de la informacion
    final Map<String, dynamic> decodedata =
        json.decode(response1.body); //respuesta

    //3. en caso que la lsita este vacia
    if (decodedata == null) return []; //== null regresasr lista vacia
    //4. ciclo for con los nodod y la informaicon

    //patronblock controlar el tokken
    if (decodedata['error'] != null)
      return []; //aqui aconsejan enviar al usuario al login si el tokken expiro

    //print(decodedata);
    // ignore: non_constant_identifier_names
    decodedata.forEach((id_nodo, value_json) {
      print(id_nodo);
      print('Decodedata_productos $decodedata');
      print(id_nodo);
      print(value_json);

      final prodtemp = Productomodel.fromJson(value_json);
      prodtemp.id = id_nodo; //asignamos el valor de los nodos al id

      productosList.add(prodtemp);
    });

    return productosList; //retorna lista de firebase
  }

  //ELIMINAMOS/DElente
  Future<int> borrar_producto(String id_nodo) async {
    final Uri url_productos =
        Uri.parse('$_url_bbdd/productos/$id_nodo.json'); //libre
    // '$_url_bbdd/productos/$id_nodo.json?auth=${_pref_user.token}'); //auth

    final response1 = await http.delete(url_productos); //ELIMINAMOS

    print(json.decode(response1.body));

    return 1; //retorna lista de firebase
  }

  //editar un nodo de firebase
  //  //update actualizar
  Future<int> editar_productos(Productomodel producto_model) async {
    //async
    //

    final Uri url_productos =
        Uri.parse('$_url_bbdd/productos/${producto_model.id}.json'); //nodo

    //-http.post()
    final response1 = await http.put(url_productos,
        body: productomodelToJson(producto_model)); //envia todo el cuarpo model

    final decodedata = json.decode(response1.body); //respuesta
    // print(' decode data =$decodedata');

    return 1;
  }

  //-----------API IMAGENES ABAJO------------------//////////////////////////////////////

  //subir imagen y guardarla en firebase
  // //file es literal filas del dispositivo
  Future<String> subirimagen(File imagen_seleccionada) async {
    final Uri url_BBDD = Uri.parse(
        'https://api.cloudinary.com/v1_1/dyfjvet1m/image/upload?upload_preset=rnjrehli'); //url base de datos de imagenes para agregar imagenes //htttp/keunube/upload

    final mimetype = mime(imagen_seleccionada
        .path); //imagenes/imagen1.jpg obteiene la ruta directa

    final image_upload_Request =
        http.MultipartRequest('POST', url_BBDD); //methodo a la bBBDD post

    //requuiere import 'package:http_parser/http_parser.dart';
    //definimos el archivo : /fila , imagen.path, archivo seleccionado
    final file_img = await http.MultipartFile.fromPath(
        'file', imagen_seleccionada.path,
        contentType: MediaType(
            mimetype[0],
            mimetype[
                1])); //tipo de objeto a enviar una fila  de la imagen seleccionada
    image_upload_Request.files.add(file_img); //1 archivo
    //podemos especificar multples archivos asi
    // image_upload_Request.files.add(file_img); //1
    // image_upload_Request.files.add(file_img); //2

    final streamResponse_1 = await image_upload_Request.send();

    final resp = await http.Response.fromStream(
        streamResponse_1); //respuesta tradiciona con body
    //verificams si la respuesta!=200
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio MAL');
      return null;
    }

    //
    final responsedatata = json.decode(resp.body);

    return responsedatata["secure_url"];
  }
}
