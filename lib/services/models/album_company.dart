class AlbumCompany {
  final List<dynamic> data;

  const AlbumCompany({
    required this.data,
  });

  factory AlbumCompany.fromJson(Map<String, dynamic> json) {
    return AlbumCompany(
      data: json['data'],
    );
  }
}
