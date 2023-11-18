class Payment {
  final String img;
  final String name;
  bool isPicked;

  Payment({
    required this.img,
    required this.name,
    this.isPicked = false,
  });
}
