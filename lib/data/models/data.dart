import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Data {
  final String title;
  final String body;

  const Data({
    required this.title,
    required this.body,
  });

  Data copyWith({
    String? title,
    String? body,
  }) {
    return Data(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'content': body,
    };
  }

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      title: map['title'] as String,
      body: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Data.fromJson(String source) =>
      Data.fromMap(json.decode(source) as Map<String, dynamic>);
}
