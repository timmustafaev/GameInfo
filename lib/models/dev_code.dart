import 'dart:convert';

class dev_code {
  String code;
  bool isFree;

  dev_code({
    required this.code,
    required this.isFree,
  });

  dev_code.fromJson(Map<String, dynamic> json)
      : this(
          code: json['code'],
          isFree: json['isFree'],
        );

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'isFree': isFree,
    };
  }
}

