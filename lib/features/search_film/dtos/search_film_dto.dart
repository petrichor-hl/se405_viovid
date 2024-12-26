class SearchFilmDto {
  final String searchText;
  final int pageIndex;
  final int pageSize;

  SearchFilmDto({
    required this.searchText,
    required this.pageIndex,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchText': searchText,
      'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
  }
}
