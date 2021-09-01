import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_block.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  // final pp_http = new ProductosProvider(); //http //cambiamos este alusar el patron block

  @override
  Widget build(BuildContext context) {
    //  final bloc = Provider.of(context);
    final productosblock = Provider.product_block(context);
    productosblock.cargarproductos();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: _crearlistadoproductos(productosblock),
      floatingActionButton: _crearboton1(context),
    );
  }

  Widget _crearlistadoproductos(ProductosBlock producto_blcok) {
    //debemos apsar un stream builder por el patron block
    return StreamBuilder(
      stream: producto_blcok.productosstream,
      builder:
          (BuildContext contex, AsyncSnapshot<List<Productomodel>> snapshot) {
        if (snapshot.hasData) {
          final productos_snap = snapshot.data;
          return ListView.builder(
              itemCount: productos_snap.length,
              itemBuilder: (context, i) =>
                  _crearitems(context, producto_blcok, productos_snap[i]));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

    //body
  }

  //aqui creo la vista de los objetos que traemso de firebase
  Widget _crearitems(BuildContext context, ProductosBlock productosBlock,
      Productomodel prod_model) {
    return Dismissible(
        //qui esta la logica para moverlo hacia el lado
        key: UniqueKey(), //valle
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          //acccion cuando termian de desplazarce de lado
          //borrar prodcuto
          //pp_http.borrar_producto(prod_model.id);
          productosBlock.borrar_producto(prod_model.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              //hacemos de cuenta que la iagen es opcional
              (prod_model.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : //si tenemos la foto
                  FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(prod_model.fotoUrl),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                  //informacion
                  title: Text('${prod_model.titulo}-${prod_model.valor}'),
                  subtitle: Text('${prod_model.id}'),
                  onTap: () {
                    Navigator.pushNamed(context, 'producto',
                        arguments:
                            prod_model); //pasar entre paginas /y enviar los argumentos(bundle)
                  }),
            ],
          ),
        ));
  }

//btn para agregar nuevos prodcutos
  _crearboton1(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'producto'));
  }
}

/* Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: ${ bloc.email }'),
            Divider(),
            Text('Password: ${ bloc.password }')
          ],
      ),*/
