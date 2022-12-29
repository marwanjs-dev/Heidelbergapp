String introduceCommas({required String balance}) {
  String newBalance = "";
  for (var i = 0; i < balance.length; i++) {
    if (i % 3 == 0 && i != 0) {
      newBalance += ",";
    }
    newBalance += balance[i];
  }
  return newBalance;
}
