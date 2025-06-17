// models.dart
class MenuItem {
  final String name;
  final double price;
  final String image;

  MenuItem({
    required this.name,
    required this.price,
    required this.image,
  });

  // 添加 equals 和 hashCode 方法确保正确比较
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuItem &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              price == other.price &&
              image == other.image;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ image.hashCode;
}

class Store {
  final String name;
  final String location;
  final String image;
  final List<MenuItem> menu;

  Store({
    required this.name,
    required this.location,
    required this.image,
    required this.menu,
  });
}

class Voucher {
  final String code;
  final double discount;

  Voucher({required this.code, required this.discount});
}