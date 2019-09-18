import 'dart:convert';
import 'dart:core';

import 'package:form/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;


class UsuarioProvider {

  final String _apiKey = 'AIzaSyCNqq9NqFNzki-5HrSWtSVcPkbUmgQsE38';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_apiKey',
      body: json.encode(authData)
    );
    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);
    if(decodeResp.containsKey('idToken')){
      //todo es valido
      //TODO: Salvar el token en el storage
      _prefs.token = decodeResp['idToken'];
      return {'ok': true, 'token': decodeResp['idToken']};
    }else {
      return {'ok':false, 'mensaje': decodeResp['error']['message']};
    }
  }
  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_apiKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);
    print(decodeResp);
    if(decodeResp.containsKey('idToken')){
      //todo es valido
      //TODO: Salvar el token en el storage
      _prefs.token = decodeResp['idToken'];
      return {'ok': true, 'token': decodeResp['idToken']};
    }else {
      return {'ok':false, 'mensaje': decodeResp['error']['message']};
    }
  }
}