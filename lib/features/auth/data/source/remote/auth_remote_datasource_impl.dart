import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/exceptions/invalid_credentials_exception.dart';
import 'package:drahkma/core/exceptions/user_not_allowed_exception.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/auth/data/source/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';
import 'package:requests/requests.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {

  static final String authUrl = "${Config.urlApi}auth/login";

  @override
  Future<UserModel?> login(Auth auth) async {
    final response = await Requests.post(
      authUrl,
      // json: {
      //   'username': auth.getEmail,
      //   'password': auth.getPassword,
      // },
      json: (auth as AuthModel).toMap(),
      headers: {'Content-type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return UserModel.toObject(response.json());
    }else if (response.statusCode == 400) {
      var json = response.json();
      throw InvalidCredentialsException(json['message'] ?? "Email ou senha inválidos.");
    }else if (response.statusCode == 403) {
      throw UserNotAllowedException();
    }else{
      return null;
    }
  }

  
  Future<Map> forgetPassword(String email) async {
    var req = await Requests.post('${Config.urlApi}auth/forget-password',
        json: {"email": email},
        headers: {'Content-type': 'application/json'},
        timeoutSeconds: 60,
        verify: false);

    if (req.statusCode == 500) {
      return {"errors": "Internal server error"};
    } else if (req.statusCode != 200) {
      throw Exception(req.json()['error']);
    } else {
      return req.json();
    }
  }

  Future<Map> forgetPasswordCode(
      String email, String code, String password, String confPassword) async {
    var req = await Requests.post('${Config.urlApi}auth/forget-password/$email',
        headers: {'Content-type': 'application/json'},
        timeoutSeconds: 20,
        verify: false,
        json: {
          'code': code,
          'password': password,
          'confpassword': confPassword
        });

    if (req.statusCode == 200) {
      return req.json();
    } else {
      var json = req.json();
      if (json['message'] != null) {
        return {'error': json['message']};
      }
      return json;
    }
  }

  @override
  Future<bool> checkSession(User data) async {
    data = data as UserModel;
    var request = await Requests.get("${Config.urlApi}user", headers: {
      'Authorization': " Bearer ${data.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (request.statusCode == 200) {
      return true;
    }return false;
  }
}