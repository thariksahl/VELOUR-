/// Currency conversion utility to LKR.
String formatLKR(double usdPrice) {
  final lkr = (usdPrice * 280).round();
  return "LKR ${lkr.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}";
}
