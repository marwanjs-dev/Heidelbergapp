class AlbumBalance {
  final List<dynamic> data;

  const AlbumBalance({
    required this.data,
  });

  factory AlbumBalance.fromJson(Map<String, dynamic> json) {
    return AlbumBalance(
      data: json['data'],
    );
  }
}
