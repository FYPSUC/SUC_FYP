// models.dart
// NOTE: Using fetchStoreWithProduct (not getVendorProducts).
class MenuItem {
  final int id;
  final String name;
  final double price;
  final String image;
  final int isSoldOut;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.isSoldOut,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    print("Raw isSoldOut from json: ${json['isSoldOut']}");
    print("Full JSON item: $json");

    return MenuItem(

      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
      isSoldOut: int.tryParse(json['isSoldOut'].toString()) ?? 0,


    );


  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MenuItem &&
              runtimeType == other.runtimeType &&
              id == other.id && // 👈 用 id 替代 name+price
              name == other.name &&
              price == other.price &&
              image == other.image;


  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ image.hashCode;
}

class Store {
  final String vendorUID;
  final String name;
  final String location;
  final String image;
  final List<MenuItem> menu;

  Store({
    required this.vendorUID,
    required this.name,
    required this.location,
    required this.image,
    required this.menu,
  });

  factory Store.fromJson(Map<String, dynamic> json) {

    return Store(
      vendorUID: json['FirebaseUID']?.toString() ?? '',
      name: json['store_name'],
      location: json['location'],
      image: json['ad_image'],
      menu: ((json['menu'] ?? json['products']) as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),


    );
  }
}
class Voucher {
  final int id;
  final String name;
  final String vendorUID;
  final String vendorName;
  final double discount;
  final String expiredDate;

  Voucher({
    required this.id,
    required this.name,
    required this.vendorUID,
    required this.vendorName,
    required this.discount,
    required this.expiredDate,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: int.tryParse(json['VoucherID']?.toString() ?? json['id']?.toString() ?? '') ?? -1,
      name: json['VoucherName'] ?? json['name'] ?? '',
      vendorUID: json['FirebaseUID'] ?? '',
      vendorName: json['VendorName'] ?? json['vendorName'] ?? '',
      discount: double.tryParse(json['DiscountAmount']?.toString() ?? json['discount']?.toString() ?? '0') ?? 0.0,
      expiredDate: json['ExpiredDate'] ?? json['date'] ?? '',
    );
  }
}
