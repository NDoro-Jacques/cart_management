import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_app/constantes/api_constantes.dart';
import 'package:http/http.dart' as http;

class ProduitService {
  Future<List<dynamic>> recupererProduits() async {
    String url = '${ApiConstantes.urlBase}/products';
    final resultat = await http.get(
        Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'}
    );
    
    return jsonDecode(utf8.decode(resultat.bodyBytes));
  }
}