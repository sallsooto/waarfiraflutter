import 'package:waarfira/core/config/api-config.dart';
import 'package:waarfira/core/model/UserExtra.dart';
import 'package:waarfira/core/model/user-details.dart';
import 'package:waarfira/core/service/user-service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class UserDetailsService {
  final _storage = new FlutterSecureStorage();
  UserDetails _userDetails;
  UserService _userService;
  List<UserExtra> userExtras = [];
  Future<void> getAndstoreUserDetails() async {
    final token = await _storage.read(key: 'token').then((value) => value);
    await http
        .get(Uri.parse(ApiConfig.URI + '/api/account'), headers: {
          HttpHeaders.authorizationHeader: "Bearer " + token,
          HttpHeaders.contentTypeHeader: 'application/json',
        })
        .then((response) async => {
              if (response.statusCode == HttpStatus.ok && response.body != null)
                {
                  _userService = new UserService(),
                  _storage.write(key: 'userDetails', value: response.body),
                  _userDetails =
                      UserDetails.fromJson(jsonDecode(response.body)),
                  /* await _userService.getUserExtras().then((value) => {
                        if (value != null)
                          {
                            userExtras = (jsonDecode(value.body)
                                    .map((i) => UserExtra.fromJson(i))
                                    .toList())
                                .cast<UserExtra>()
                                .toList(),
                            print("nombre de users extra:" +
                                userExtras.length.toString()),
                            userExtras.forEach((element) {
                              if (element.matricule != null &&
                                  element.user != null &&
                                  element.user.id == _userDetails.id) {
                                _storage.write(
                                    key: 'matricule', value: element.matricule);
                              }
                            })
                          }
                      }), */
                  print('le token est:' + token),
                }
              else
                {
                  print('get users details error with ' +
                      response.statusCode.toString() +
                      ' code'),
                }
            })
        .catchError((e) => {
              // ignore: invalid_return_type_for_catch_error
              print('get users details error'),
              print(e),
            });
  }

  Future<UserDetails> getStoredUserDetails() async {
    String userDetailsString;
    await _storage
        .read(key: 'userDetails')
        .then((value) => userDetailsString = value);
    if (userDetailsString != null) {
      try {
        _userDetails = UserDetails.fromJson(jsonDecode(userDetailsString));
        return _userDetails;
      } catch (e) {
        print('userdetails stored to userDetails object conversion failed');
        print(e);
      }
    }
    return null;
  }

  void clearUsersDetailsOnSecureStorage() async {
    await _storage.delete(key: "userDetails");
  }
}
