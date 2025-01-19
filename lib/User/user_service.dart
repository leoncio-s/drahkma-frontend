import 'dart:convert';

import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';

class UserService {
  static Future<UserDto?> profile() async {
    var data = await AuthService.getAuthUser();
    var request = await Requests.get("${Config.urlApi}user", headers: {
      'Authorization': " Bearer ${data?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (request.statusCode != 200) {
      throw Exception('Token inválido ou usuário não autorizado');
    }
    var user = UserDto();
    user = user.toObject(jsonDecode(request.body));

    return user;
  }

  static Future<dynamic> register(Map data) async {
    try {
      var request = await Requests.post("${Config.urlApi}user",
          json: data,
          headers: {'Content-type': 'application/json'});

      if (request.statusCode == 201) {
        return UserDto().toObject(request.json());
      } else {
        return request.json();
      }
    } catch (e) {
      return {"error": "Erro ao processar solicitação."};
    }
  }
}
