

import 'dart:io';
import 'package:form/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';


import 'package:flutter/material.dart';
import 'package:form/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ProductosProvider {
  final String _url = 'https://firechat-7a4dc.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final respo = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(respo.body);
    print(decodedData);

    return true;

  }


  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp  = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if(decodedData == null ) return [];

    if(decodedData['error'] != null) return [];
    decodedData.forEach((id, prod) {
      final prodTem = ProductoModel.fromJson(prod);
      prodTem.id = id;
      productos.add(prodTem);
    });


    return productos;
  }

  Future<int> borrarProduct(String id) async {
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));
    return 1;
  }


   Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final respo = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(respo.body);
    print(decodedData);

    return true;

  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dyvextynp/image/upload?upload_preset=ibc87yrk');
    final mimeType = mime(imagen.path).split('/');
    
    final imageUploadRequist = http.MultipartRequest(
      'POST',
      url,
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path, 
      contentType: MediaType(mimeType[0], mimeType[1])
    );
    imageUploadRequist.files.add(file);

    final streamResponse = await imageUploadRequist.send();

    final resp = await http.Response.fromStream(streamResponse);
    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}