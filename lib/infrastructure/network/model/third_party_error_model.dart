// To parse this JSON data, do
//
//     final thirdPartyErrorModel = thirdPartyErrorModelFromJson(jsonString);

import 'dart:convert';

ThirdPartyErrorModel thirdPartyErrorModelFromJson(String str) => ThirdPartyErrorModel.fromJson(json.decode(str));

String thirdPartyErrorModelToJson(ThirdPartyErrorModel data) => json.encode(data.toJson());

class ThirdPartyErrorModel {
  int? errorCode;
  String? errorMessage;
  ThirdPartyError? thirdPartyError;
  String? thirdPartyHttpStatus;
  List<Detail>? details;

  ThirdPartyErrorModel({
    this.errorCode,
    this.errorMessage,
    this.thirdPartyError,
    this.thirdPartyHttpStatus,
    this.details,
  });

  factory ThirdPartyErrorModel.fromJson(Map<String, dynamic> json) => ThirdPartyErrorModel(
    errorCode: json['errorCode'],
    errorMessage: json['errorMessage'],
    thirdPartyError: json['thirdPartyError'] == null ? null : ThirdPartyError.fromJson(json['thirdPartyError']),
    thirdPartyHttpStatus: json['thirdPartyHttpStatus'],
    details: json['details'] == null ? [] : List<Detail>.from(json['details']!.map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'errorCode': errorCode,
    'errorMessage': errorMessage,
    'thirdPartyError': thirdPartyError?.toJson(),
    'thirdPartyHttpStatus': thirdPartyHttpStatus,
    'details': details == null ? [] : List<dynamic>.from(details!.map((x) => x.toJson())),
  };
}

class Detail {
  String? locationOccur;
  String? errorMessage;

  Detail({
    this.locationOccur,
    this.errorMessage,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    locationOccur: json['locationOccur'],
    errorMessage: json['errorMessage'],
  );

  Map<String, dynamic> toJson() => {
    'locationOccur': locationOccur,
    'errorMessage': errorMessage,
  };
}

class ThirdPartyError {
  int? thirdPartyErrorCode;
  String? thirdPartyErrorMessage;
  String? errorMessage;
  String? enErrorMessage;
  String? errorCode;

  ThirdPartyError({
    this.thirdPartyErrorCode,
    this.thirdPartyErrorMessage,
    this.errorMessage,
    this.enErrorMessage,
    this.errorCode,
  });

  factory ThirdPartyError.fromJson(Map<String, dynamic> json) => ThirdPartyError(
    thirdPartyErrorCode: json['thirdPartyErrorCode'],
    thirdPartyErrorMessage: json['thirdPartyErrorMessage'],
    errorMessage: json['error_message'],
    enErrorMessage: json['en_error_message'],
    errorCode: json['error_code'],
  );

  Map<String, dynamic> toJson() => {
    'thirdPartyErrorCode': thirdPartyErrorCode,
    'thirdPartyErrorMessage': thirdPartyErrorMessage,
    'error_message': errorMessage,
    'en_error_message': enErrorMessage,
    'error_code': errorCode,
  };
}
