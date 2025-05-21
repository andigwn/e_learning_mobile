// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'data': instance.data, 'message': instance.message};

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  username: json['username'] as String,
  id_role: (json['id_role'] as num).toInt(),
  token: json['token'] as String,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'username': instance.username,
  'id_role': instance.id_role,
  'token': instance.token,
};
