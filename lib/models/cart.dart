class CartModel {
  String id = '';
  String number = '';
  String name = '';
  String invoiceNumber = '';
  int price = 0;
  String unit = '';
  int category = 0;
  int requestQuantity = 0;
  int deliveryQuantity = 0;

  CartModel.fromMap(Map map) {
    id = map['id'] ?? '';
    number = map['number'] ?? '';
    name = map['name'] ?? '';
    invoiceNumber = map['invoiceNumber'] ?? '';
    price = map['price'] ?? 0;
    unit = map['unit'] ?? '';
    category = map['category'] ?? 0;
    requestQuantity = map['requestQuantity'] ?? 0;
    deliveryQuantity = map['deliveryQuantity'] ?? 0;
  }

  Map toMap() => {
        'id': id,
        'number': number,
        'name': name,
        'invoiceNumber': invoiceNumber,
        'price': price,
        'unit': unit,
        'category': category,
        'requestQuantity': requestQuantity,
        'deliveryQuantity': deliveryQuantity,
      };
}
