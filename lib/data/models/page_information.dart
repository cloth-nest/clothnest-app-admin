import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PageInformation {
  final int limit;
  final int offset;
  final int currentPageNum;
  final int totalCount;
  final int? nextPageNum;
  final int lastPageNum;
  final bool hasNextPage;
  final bool hasPrevPage;

  PageInformation({
    required this.limit,
    required this.offset,
    required this.currentPageNum,
    required this.totalCount,
    required this.nextPageNum,
    required this.lastPageNum,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'currentPageNum': currentPageNum,
      'totalCount': totalCount,
      'nextPageNum': nextPageNum,
      'lastPageNum': lastPageNum,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }

  factory PageInformation.fromMap(Map<String, dynamic> map) {
    return PageInformation(
      limit: map['limit'] as int,
      offset: map['offset'] as int,
      currentPageNum: map['currentPageNum'] as int,
      totalCount: map['totalCount'] as int,
      nextPageNum: map['nextPageNum'],
      lastPageNum: map['lastPageNum'] as int,
      hasNextPage: map['hasNextPage'] as bool,
      hasPrevPage: map['hasPrevPage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory PageInformation.fromJson(String source) =>
      PageInformation.fromMap(json.decode(source) as Map<String, dynamic>);
}
