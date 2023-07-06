import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:classifields_apk_flutter/src/enviroments/enviroments.dart';
import 'package:classifields_apk_flutter/src/models/user_model.dart';
import 'package:classifields_apk_flutter/src/services/storage_service.dart';
import 'package:classifields_apk_flutter/src/services/logging_interceptor.dart';

class UserController {
  final env = Environments();

  final client = LoggingInterceptor();

  final storageService = StorageService();

  Future<dynamic> createUserNameUnique(String? userName) async {
    try {
      if (userName == '' || userName == null) {
        return;
      }

      http.Response response = await client.get(
        Uri.parse('${env.baseUrl}/user/createUserNameUnique/$userName'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final validate = jsonDecode(response.body);
        return validate;
      } else {
        print('aconteceu um erro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e ,Error in create user');
    }
  }

  Future<dynamic> verifyEmailExists(String email) async {
    try {
      if (email == '' || email == null) {
        return;
      }

      http.Response response = await client.get(
        Uri.parse('${env.baseUrl}/user/verifyEmailExists/$email'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final validate = jsonDecode(response.body);
        return validate;
      } else {
        print('aconteceu um erro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e ,Error in create user');
    }
  }

  Future<dynamic> createUser(body) async {
    try {
      String jsonBody = jsonEncode(body);

      Map<String, String> headers = {'Content-Type': 'application/json'};

      http.Response response = await http.post(Uri.parse('${env.baseUrl}/user'),
          headers: headers.cast<String, String>(), body: jsonBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final user = UserModel.fromMap(jsonDecode(response.body));

        return user;
      } else {
        print('aconteceu um erro: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('$e ,Error in create user');
      return null;
    }
  }

  Future<dynamic> updatePatchUser(int? userId ,body) async {
    try {
      String jsonBody = jsonEncode(body);
      String? token = '';      

      await userLocalData().then((value) => {
        token = value.token,        
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };           

      http.Response response = await client.patch(Uri.parse('${env.baseUrl}/user/$userId'),
          headers: headers.cast<String, String>(), body: jsonBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final user = UserModel.fromMap(jsonDecode(response.body));

        return user;
      } else {
        print('aconteceu um erro: ${response.statusCode}, ${response.body}, METHOD => updatePatchUser');
        return null;
      }
    } catch (e) {
      print('$e ,Error in create user, METHOD => updatePatchUser');
      return null;
    }
  }

  Future<dynamic> getUserById(int? userId) async {
    try {
      String? token = '';

      await userLocalData().then((value) => {token = value.token});

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

      http.Response response = await client
          .get(Uri.parse('${env.baseUrl}/user/$userId'), headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        UserModel user = UserModel.fromMap(jsonDecode(response.body));
        return user;
      } else {
        print('aconteceu um erro: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e ,Error in create user');
    }
  }

  Future userLocalData() async {
    try {
      final localDataReturned =
          await storageService.getLocalData(key: ConstantsApk.userLogado);

      if (localDataReturned != null) {
        final localData = jsonDecode(localDataReturned);        

        if (localData != null) {
          return UserModel.fromMap(localData['user']);
        } else {
          return null;
        }
      }
    } catch (err) {
      print('aconteceu um erro: $err, userLocalData');
      throw Exception('$err ,Error in create user');
    }
  }

  Future<dynamic> deleteImageAvatar(int? userId, String? fileName) async {
    try {
      String? token = '';

      await userLocalData().then((value) => {token = value.token});

      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
      };

      http.Response response = await client
          .delete(Uri.parse('${env.baseUrl}/media-avatar/$userId/$fileName'), headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {        
        return true;
      } else {
        print('aconteceu um erro: ${response.statusCode}, method => deleteImageAvatar');
        return false;
      }
    } catch (e) {
      throw Exception('$e ,Error in create user, method => deleteImageAvatar');
    }
  }


  Future<dynamic> addMediaAvatarUser(int? userId ,body) async {
    try {
      String jsonBody = jsonEncode(body);
      String? token = '';      

      await userLocalData().then((value) => {
        token = value.token,        
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };      

      http.Response response = await client.post(Uri.parse('${env.baseUrl}/media-avatar/$userId'),
          headers: headers.cast<String, String>(), body: jsonBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final mediaAddedResponse = UserModel.fromMap(jsonDecode(response.body));

        return mediaAddedResponse;
      } else {
        print('aconteceu um erro: ${response.statusCode}, ${response.body}, METHOD => addMediaAvatarUser');
        return null;
      }
    } catch (e) {
      print('$e ,Error in create user, METHOD => addMediaAvatarUser');
      return null;
    }
  }


  Future<dynamic> comparePasswordUser(body) async {
    try {
      String jsonBody = jsonEncode(body);
      String? token = '';      
      int? userId;

      await userLocalData().then((value) => {
        token = value.token,
        userId = value.id        
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };      

      print('token, token, $userId');

      http.Response response = await client.post(Uri.parse('${env.baseUrl}/user/comparePasswordUser/$userId'),
          headers: headers.cast<String, String>(), body: jsonBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final resp = jsonDecode(response.body);

        return resp;
      } else {
        print('aconteceu um erro: ${response.statusCode}, ${response.body}, METHOD => comparePasswordUser');
        return null;
      }
    } catch (e) {
      print('$e ,Error in create user, METHOD => comparePasswordUser');
      return null;
    }
  }


  Future<dynamic> updatePasswordUser(body) async {
    try {
      String jsonBody = jsonEncode(body);
      String? token = '';      
      int? userId;

      await userLocalData().then((value) => {
        token = value.token,
        userId = value.id        
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };      

      print('token, token, $body');

      http.Response response = await client.post(Uri.parse('${env.baseUrl}/user/updatePassword/$userId'),
          headers: headers.cast<String, String>(), body: jsonBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final resp = jsonDecode(response.body);

        return resp;
      } else {
        print('aconteceu um erro: ${response.statusCode}, ${response.body}, METHOD => updatePasswordUser');
        return null;
      }
    } catch (e) {
      print('$e ,Error in create user, METHOD => updatePasswordUser');
      return null;
    }
  }

}
