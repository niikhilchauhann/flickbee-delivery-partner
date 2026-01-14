import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiServices {
  Map<String, String> _headers = {};

  void _initHeaders() => _headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    // if (LocalStorageServices.authToken() != null) 'Authorization': 'Bearer ${LocalStorageServices.authToken()}',
  };

  Future<dynamic> getRequest(String apiUrl) async {
    // if (hasConnection) {
    _initHeaders();
    final url = Uri.parse(apiUrl);

    log(
      "--------------- API GET SENT -----------\nlocation-$url\nheaders-$_headers",
    );

    final response = await http.get(url, headers: _headers);
    return _handleApiResponse(endpoint: apiUrl, response: response);
    // }
    // return null;
  }

  Future<dynamic> postRequest(
    String apiUrl, {
    Map<String, dynamic>? body,
  }) async {
    // if (hasConnection) {
    _initHeaders();
    final url = Uri.parse(apiUrl);

    log(
      "--------------- API POST SENT -----------\nlocation-$url\nreq-$body\nheaders-$_headers",
    );

    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode(body),
    );
    return _handleApiResponse(endpoint: apiUrl, response: response);
    // }
    // return null;
  }

  Future<dynamic> _handleApiResponse({
    required http.Response response,
    required String endpoint,
  }) async {
    try {
      switch (response.statusCode) {
        case HttpStatus.ok || HttpStatus.created:
          final json = jsonDecode(response.body);
          //log("--------------- API SUCCESS -----------\nlocation-$endpoint\nres-$json");
          return json;
        case HttpStatus.unauthorized || HttpStatus.forbidden:
          // await LocalStorageServices.deleteData(LocalStorageKeys.authToken);
          throw CustomException(message: "$endpoint $json", isUnAuth: true);

        case HttpStatus.internalServerError:
          final json = jsonDecode(response.body);
          log(json.toString());
          throw CustomException(
            message: "Internal Server Error, Please try again later",
          );
        default:
          Map<String, dynamic> json = {'error': "Something went wrong"};
          try {
            json = jsonDecode(response.body);
          } catch (e) {
            log(e.toString());
          }
          json['error'] == null
              ? throw CustomException(message: json.toString())
              : throw CustomException(message: json['error'].toString());
      }
    } on CustomException catch (error) {
      log(
        "--------------- API FAILED -----------\nlocation-$endpoint\nres-$json\n$error",
      );
      if (error.toString() == "Active Van Salesman not found") {
        // AppPrompts.showInfoDialog("Van is not assign to this salesman", notAssign: true);
        return null;
      }
      // AppPrompts.showInfoDialog(error.toString());
    }
    return null;
  }

  static const String _fieldName = 'files';

  Future<dynamic> uploadImage({
    File? image,
    String? userId,
    List<File>? files,
  }) async {
    final multipartRequest = http.MultipartRequest('POST', Uri.parse(''));
    // multipartRequest.headers['Authorization'] = 'Bearer ${LocalStorageServices.authToken()}';

    try {
      if (image != null) {
        final filename = image.path.split('/').last;
        final multipartFile = await http.MultipartFile.fromPath(
          _fieldName,
          image.path,
          filename: filename,
        );
        multipartRequest.files.add(multipartFile);
      } else if (files != null) {
        for (final image in files) {
          final filename = image.path.split('/').last;
          final multipartFile = await http.MultipartFile.fromPath(
            _fieldName,
            image.path,
            filename: filename,
          );
          multipartRequest.files.add(multipartFile);
        }
      }
      final response = await multipartRequest.send();
      final responseData = await response.stream.bytesToString();
      final json = jsonDecode(responseData);
      if (json['success']) {
        return List.generate(
          json['data'].length,
          (index) => Media.fromJson(json['data'][index]),
        );
      } else {
        return json.toString();
      }
    } on SocketException {
      // AppPrompts.showInfoDialog("No Internet Connection");
    } catch (e) {
      log("UPLOAD ERROR: $e");
      return e.toString();
    }
  }
}

class CustomException implements Exception {
  final String message;
  final bool isUnAuth;
  final bool notAssign;

  const CustomException({
    required this.message,
    this.isUnAuth = false,
    this.notAssign = false,
  });

  @override
  String toString() => message;
}

class Media {
  final String id;
  final String type;
  final String url;
  final String userType;
  final String createdBy;
  final String ownerId;
  final String domainId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Media({
    required this.id,
    required this.type,
    required this.url,
    required this.userType,
    required this.createdBy,
    required this.ownerId,
    required this.domainId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json['id'] ?? '',
    type: json['type'] ?? '',
    url: json['url'] ?? '',
    userType: json['userType'] ?? '',
    createdBy: json['createdBy'] ?? '',
    ownerId: json['ownerId'] ?? '',
    domainId: json['domainId'] ?? '',
    status: json['status'] ?? '',
    createdAt: DateTime.parse(json['createdAt'] ?? '2025-01-01T00:00:00.000Z'),
    updatedAt: DateTime.parse(json['updatedAt'] ?? '2025-01-01T00:00:00.000Z'),
  );
}
