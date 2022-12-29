class Album {
  final String customerCode;
  final String customerName;
  final List<dynamic> balances;

  const Album({
    required this.customerCode,
    required this.customerName,
    required this.balances,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      customerCode: json['customerCode'],
      customerName: json['customerName'],
      balances: json['balances'],
    );
  }
}
