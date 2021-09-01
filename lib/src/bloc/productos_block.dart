import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBlock {
  //controlamos con streams los productos para cambiarlos simultaneamente en cua uier parte d enustra appa
//uno para volverlos a cargar y otro cuando esta subiendo informacion
//
  final _productoController = new BehaviorSubject<List<Productomodel>>();
  final _cargandoController = new BehaviorSubject<bool>();

//referencia
  final _producto_provider = new ProductosProvider(); //peticions a firebase

  //escuchar stream del provider y stream del canal
  ////funcion para reducir codigo que reuselve una lista de productos model
  Stream<List<Productomodel>> get productosstream => _productoController.stream;
  Stream<bool> get cargando_productos => _cargandoController.stream;

  //aqui ponderemos methodos ara cargar productos  y cuando lo usemos agregar o cargar
  //
  void cargarproductos() async {
    final productos =
        await _producto_provider.cargar_productos(); //trae la lsita d efirebase
    _productoController.sink.add(productos);
  }

  void agregarunproducto(Productomodel producto_modelo) async {
    _cargandoController.sink.add(true); //estoy cargando
    await _producto_provider.crearproducto(producto_modelo);
    _cargandoController.sink.add(false); //termino de cargar
  }

//parece haber problemas para subir la foto con patron blocck
  Future<String> subirfoto(File foto_file) async {
    _cargandoController.sink.add(true); //estoy cargando
    final fotourl = await _producto_provider.subirimagen(foto_file);
    _cargandoController.sink.add(false); //termino de cargar
    return foto_file.path;
  }

  void editarproductos(Productomodel producto_modelo) async {
    _cargandoController.sink.add(true); //estoy cargando
    await _producto_provider.editar_productos(producto_modelo);
    _cargandoController.sink.add(false); //termino de cargar
  }

  void borrar_producto(String id_producto) async {
    await _producto_provider.borrar_producto(id_producto);
  }

//redibuje el wiget cuando no lo usamos .close()
  dispose() {
    _productoController?.close();
    _cargandoController?.close();
  }
}
