/// Generic paginated response model
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    bool? hasMore,
  }) : hasMore = hasMore ?? ((page * pageSize) < total);

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final items =
        (json['items'] as List?)
            ?.map((item) => fromJsonT(item as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedResponse(
      items: items,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      hasMore: json['hasMore'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'items': items.map((item) => toJsonT(item)).toList(),
    'total': total,
    'page': page,
    'pageSize': pageSize,
    'hasMore': hasMore,
  };
}
