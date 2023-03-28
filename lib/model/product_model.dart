
class Product {
  Product(
    this.title,
    this.price,
    this.description,
    this.type,
    this.size,
    this.imageurl,
    this.listColor, {
    this.isfav = false,
    this.docId,
  });

  final String title;
  final int price;
  final String description;
  final String type;
  final List<String> size;
  final String imageurl;
  final List<int> listColor;
  String? docId;
  bool? isfav;
}

