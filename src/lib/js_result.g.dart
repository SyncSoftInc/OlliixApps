// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JSResult _$JSResultFromJson(Map<String, dynamic> json) => JSResult()
  ..success = json['Success'] as bool? ?? false
  ..error = json['Error'] as String? ?? ''
  ..value = json['Value'] as String? ?? '';

Map<String, dynamic> _$JSResultToJson(JSResult instance) => <String, dynamic>{
      'Success': instance.success,
      'Error': instance.error,
      'Value': instance.value,
    };
