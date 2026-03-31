import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../config/api_constants.dart';
import '../../utils/app_exception.dart';

class PokeApiService {
  final http.Client _client;
  
  PokeApiService(this._client);

  Future<Map<String, dynamic>> getPokemonByType(String typeName) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/type/$typeName');

    return _get(uri);
  }

  Future<Map<String, dynamic>> getPokemonDetail(String name) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/pokemon/$name');
    
    return _get(uri);
  }

  Future<Map<String, dynamic>> _get(Uri uri) async {
    try {
      final response = await _client.get(uri);

      if (response.statusCode != 200) {
        throw ServerException(response.statusCode);
      }

      return jsonDecode(response.body) as Map<String, dynamic>;

    } on ServerException {
      rethrow;

    } on SocketException {
      throw const NetworkException();

    } on FormatException {
      throw const ParseException();

    }
  }
}
