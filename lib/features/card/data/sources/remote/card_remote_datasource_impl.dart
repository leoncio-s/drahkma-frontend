import 'dart:convert';
import 'dart:io';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/utils/helpers/join_url.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/card/data/models/card_dto.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/data/sources/remote/card_remote_datasource.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class CardRemoteDatasourceImpl implements CardRemoteDatasource {
  static final Uri _url = Uri.parse("${Config.urlApi}cards");

  @override
  Future<List<CardModel>?> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );

    List<CardModel>? cards = [];

    if (request.statusCode == 200) {
      List<dynamic> cardsJson = jsonDecode(request.body);
      for (var card in cardsJson) {
        CardModel cardModel = CardModel.fromJson(card);
        cards.add(cardModel);
      }
    }
    return cards;
  }

  @override
  Future<CardModel?> save(CardDTO data) async {
    try {
      User? user = await getIt<AuthLocalDatasource>().getAuthToken();
      UserModel? userModel = user as UserModel?;
      var response = await http.post(
        _url,
        body: jsonEncode(data.toMap()),
        headers: {
          'Authorization': " Bearer ${userModel?.token ?? ''}",
          'Content-type': 'application/json'
        },
      );

      if (response.statusCode == 201) {
        return CardModel.fromJson(jsonDecode(response.body));
      } else {
        throw http.ClientException(response.body, _url);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> delete(CardModel data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var url = joinUrl(_url, '${data.id}');
    var response = await http.delete(
      url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );

    if (response.statusCode == 404) {
      throw http.ClientException("Página ou cartão não encontrado", url);
    } else if (response.statusCode > 499) {
      throw HttpException("Erro interno no servidor");
    } else if (response.statusCode == 400) {
      var json = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw http.ClientException(json['errors'], url);
    } else {
      throw http.ClientException("Ocorreu um problema para realizar sua solicitação. Tente novamente mais tarde!", url);
    }
  }

  @override
  Future<void> update(CardDTO data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var response =
        await http.put(_url, body: jsonEncode(data.toMap()), headers: {
      'Authorization': " Bearer ${userModel?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode == 404) {
      throw http.ClientException("Página ou cartão não encontrado", _url);
    } else if (response.statusCode > 499 || response.statusCode != 200) {
      throw HttpException("Erro interno no servidor");
    } else {
      return;
    }
  }

  @override
  Future<CardModel?> getBy({int? id}) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var url = joinUrl(_url, "$id");
    var response = await http.get(url, headers: {
      'Authorization': " Bearer ${userModel?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode == 404) {
      throw http.ClientException("Página ou cartão não encontrado", url);
    } else if (response.statusCode > 499 || response.statusCode != 200) {
      throw HttpException("Erro interno no servidor");
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      CardModel card = CardModel.fromJson(json);
      return card;
    }
  }
}
