import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_block.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
//import 'package:formvalidation/src/providers/productos_provider.dart';//eliminada para cabiar a block
import 'package:formvalidation/src/utils/utils.dart' as utilsss;
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class Productos_pague extends StatefulWidget {
  @override
  _Productos_pagueState createState() => _Productos_pagueState();
}

class _Productos_pagueState extends State<Productos_pague> {
  //keys
  final fomkey = GlobalKey<
      FormState>(); //key para reconocer el fomrulario y hacer una validacion rapida
  final scafoldkey = GlobalKey<
      ScaffoldState>(); //llave reconocer el scafold y poner objetos dentro de este
  //
  ProductosBlock productosBlock;

  //
  Productomodel productomodel = new Productomodel();
  bool btn_pulsado_bool = false;
//imagen
  File image_photo;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    productosBlock = Provider.product_block(context); //inicializamos el block

    //
    //obtenemos valor d eun bundle pasandole los parametros y señalizando que recibe argumentos
    final Productomodel product_data_bundle =
        ModalRoute.of(context).settings.arguments;

    if (product_data_bundle != null) {
      productomodel = product_data_bundle;
    }
    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(title: Text('Productos'), actions: <Widget>[
        //acfciones permiten ahcer cosas como obtener fotografcias
        IconButton(
            onPressed: () {
              _seleccionarfoto2();
            },
            icon: Icon(Icons.photo_size_select_actual)),
        IconButton(
          onPressed: () {
            _tomarfotografia();
          },
          icon: Icon(Icons.camera_alt_outlined),
        )
      ]),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: fomkey, //lave del formulario
            //este nos permite crear formularios por defecto
            child: Column(
              children: <Widget>[
                _mostrarfoto(), //image para la foto
                _crearnombre(), //edittext/textfiel
                _crearprecio(), //edittex/textfield
                _creardisponible(), //como un check
                _crearbutton(context), //button/raisedbutton
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearnombre() {
    //TextFormField= se utiliza especialmente para formularios yconecta con Form vienen por defecto
    return TextFormField(
      initialValue: productomodel
          .titulo, //aqui podemos asignar el valor a lo que recibira este texto para ponerlo en el modelo

      textCapitalization: TextCapitalization
          .sentences, //obtiene oraciones es comco etipular el tipo de campo que es
      decoration: InputDecoration(labelText: 'producto'),
      onSaved: (valor) => productomodel.titulo = valor,
      validator: (value) {
        //validamos lo que escribe en el campo
        if (value.length < 3) {
          return 'ingresar nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearprecio() {
    return TextFormField(
      initialValue: productomodel.valor.toString(), //valor del modelo

      keyboardType: TextInputType.numberWithOptions(
          decimal:
              true), //que acepte solo datos y especifica que recibe decimales
      decoration: InputDecoration(labelText: 'precio'),
      onSaved: (valor) =>
          productomodel.valor = double.parse(valor), //guarda el valor
      //valor as double, //aqui guardamos el valor que se utilizo
      validator: (valor) {
        //utils es una validacion que hice para ver si es un numero
        if (utilsss.isNumeric(valor)) {
          //si regresa un true es un numero ,
          return null;
        } else {
          return 'solo nhumero';
        }
      },
    );
  }

  Widget _crearbutton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.purple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('guardar'),
      onPressed: () {
        btn_pulsado_bool ? null : _submith(context);
      }, //methoo abajo...

      //onPressed: (btn_pulsado_bool) ? null: _submith(), //methoo abajo...
    );
  }

  Widget _creardisponible() {
    bool estado_swich = productomodel.disponible;
    if (estado_swich != null) {
      return SwitchListTile(
          title: Text('producto disponible '),
          activeColor: Colors.purple,
          value: estado_swich, //productomodel.disponible, //valor //false !true
          onChanged: (value) => setState(() {
                productomodel.disponible = value;
              }));
    } else {
      return SwitchListTile(
          title: Text('producto disponible'),
          activeColor: Colors.purple,
          value: false, //productomodel.disponible, //valor //false !true
          onChanged: (value) => setState(() {
                productomodel.disponible = value;
              }));
    }
  }

//valida el formulario que hicimos donde asignamos esta formkey
  void _submith(BuildContext context) async {
    //fomkey.currentState.validate(); //bool

    if (!fomkey.currentState.validate()) return; //negativa
    //ejecutamos el onsave de cada texfiel:
    fomkey.currentState.save();
    //print(' Todo Ok ');

    //guarda que el boolean ahora es verdadero
    setState(() {
      btn_pulsado_bool = true;
    });

    final productosprovider_http = ProductosProvider();
    // productosprovider_http.crearproducto(productomodel); //y listo

    if (image_photo != null) {
      //productomodel.fotoUrl = await productosBlock.subirfoto(image_photo);
      productosprovider_http.subirimagen(image_photo);
    }

    //si recibimos informacion debemos establecer   ue accion realizar o nuevo o sobreescribir
    if (productomodel.id == null) {
      productosBlock.agregarunproducto(//patron block
          productomodel); //.crearproducto(productomodel); //crea uno nuevo o
      mostrarsnackbar('nuevo producto', context);
    } else {
      productosBlock.editarproductos(productomodel); //block
      // .editar_productos(productomodel); //actualiza uno ya existente
      mostrarsnackbar('producto actualizado ${productomodel.titulo}', context);
    }

    //estado del btn
    setState(() {
      btn_pulsado_bool = false;
    });
  }

  //Toast /snackbar
  //nos pide una key para identificarlo
  void mostrarsnackbar(String mensaje, BuildContext context) {
    final snack = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scafoldkey.currentState.showSnackBar(snack);

    Navigator.pop(context); //return
  }

  ///fotogra1 obtener de galeria de imagenes -----------------------------

  Widget _mostrarfoto() {
    //figet para msotrar el espacio de la imagen hasta qeu eta cambie
    //si el producto tiene una foto
    if (productomodel.fotoUrl != null) {
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(productomodel.fotoUrl),
          fit: BoxFit.contain);
    } else {
      if (image_photo != null) {
        return Image.file(
          image_photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarfoto2() async {
    _procesarimagen(ImageSource.gallery);
  }

//es casi igual que el anterorio solo cambiamos la direccion de obtener la fotografia
  _tomarfotografia() async {
    _procesarimagen(ImageSource.camera);
  }

  _procesarimagen(ImageSource origen_foto) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origen_foto,
    );
    image_photo = File(pickedFile.path);

    //borra el url de la foto despues de mostrarla para que pueda mostrar una nueva  si se selecciona
    if (image_photo != null) {
      productomodel.fotoUrl = null;
    }

    //redibuja el wiget
    setState(() {
      if (pickedFile != null) {
        image_photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  ///

}
