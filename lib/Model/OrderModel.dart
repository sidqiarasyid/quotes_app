final String tableOrder = 'pesan';

class OrderFields {
  static final List<String> values = [
    id,
    items,
    tebal,
    lebar,
    panjang,
    spec,
    color,
    qty,
    disc,
    price,
  ];
  static final String id = '_id';
  static final String items = 'items';
  static final String tebal = 'tebal';
  static final String lebar = 'lebar';
  static final String panjang = 'panjang';
  static final String spec = 'spec';
  static final String color = 'color';
  static final String qty = 'qty';
  static final String disc = 'disc';
  static final String price = 'price';
}

class OrderModel {
  final int? id;
  final String items;
  final String tebal;
  final String lebar;
  final String panjang;
  final String spec;
  final String color;
  final String qty;
  final String disc;
  final String price;
  OrderModel(
      {required this.items,
      required this.tebal,
      required this.lebar,
      required this.panjang,
      required this.spec,
      required this.color,
      required this.qty,
      required this.disc,
      required this.price,
      this.id});

  static OrderModel fromJson(Map<String, Object?> json) => OrderModel(
      items: json[OrderFields.items] as String,
      tebal: json[OrderFields.tebal] as String,
      lebar: json[OrderFields.lebar] as String,
      panjang: json[OrderFields.panjang] as String,
      spec: json[OrderFields.spec] as String,
      color: json[OrderFields.color] as String,
      qty: json[OrderFields.qty] as String,
      disc: json[OrderFields.disc] as String,
      price: json[OrderFields.price] as String,
      id: json[OrderFields.id] as int?);

  Map<String, Object?> toJson() => {
        OrderFields.id: id,
        OrderFields.items: items,
        OrderFields.tebal: tebal,
        OrderFields.lebar: lebar,
        OrderFields.panjang: panjang,
        OrderFields.spec: spec,
        OrderFields.color: color,
        OrderFields.qty: qty,
        OrderFields.disc: disc,
        OrderFields.price: price,
      };
  OrderModel copy({
    int? id,
    String? items,
    String? tebal,
    String? lebar,
    String? panjang,
    String? spec,
    String? color,
    String? qty,
    String? disc,
    String? price,
  }) =>
      OrderModel(
        id: id ?? this.id,
        items: items ?? this.items,
        tebal: tebal ?? this.tebal,
        lebar: lebar ?? this.lebar,
        panjang: panjang ?? this.panjang,
        spec: spec ?? this.spec,
        color: color ?? this.color,
        qty: qty ?? this.qty,
        disc: disc ?? this.disc,
        price: price ?? this.price,
      );
}
