import 'dart:html';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hirome_rental_center_web/common/functions.dart';
import 'package:hirome_rental_center_web/common/style.dart';
import 'package:hirome_rental_center_web/models/cart.dart';
import 'package:hirome_rental_center_web/models/order.dart';
import 'package:hirome_rental_center_web/models/product.dart';
import 'package:hirome_rental_center_web/models/shop.dart';
import 'package:hirome_rental_center_web/services/cart.dart';
import 'package:hirome_rental_center_web/services/order.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderProvider with ChangeNotifier {
  CartService cartService = CartService();
  OrderService orderService = OrderService();
  List<CartModel> _carts = [];
  List<CartModel> get carts => _carts;

  DateTime searchStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );
  DateTime searchEnd = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).add(const Duration(days: -1));

  String? searchShop;

  void searchDateChange(DateTime start, DateTime end) {
    searchStart = start;
    searchEnd = end;
    notifyListeners();
  }

  void searchShopChange(String? value) {
    searchShop = value;
    notifyListeners();
  }

  Future<String?> create({
    ShopModel? shop,
    List<CartModel>? carts,
  }) async {
    String? error;
    if (shop == null) return '注文に失敗しました';
    if (carts == null) return '注文に失敗しました';
    if (carts.isEmpty) return '注文に失敗しました';
    try {
      String id = orderService.id();
      String dateTime = dateText('yyyyMMddHHmmss', DateTime.now());
      String number = '${shop.number}-$dateTime';
      List<Map> newCarts = [];
      List<CartModel> newCarts2 = [];
      for (CartModel cart in carts) {
        newCarts.add(cart.toMap());
        newCarts2.add(cart);
      }
      if (newCarts.isEmpty) {
        return '注文に失敗しました';
      }
      await _receiptPrint(
        shopName: shop.name,
        carts: newCarts2,
        createdAt: DateTime.now(),
      );
      orderService.create({
        'id': id,
        'number': number,
        'shopId': shop.id,
        'shopNumber': shop.number,
        'shopName': shop.name,
        'shopInvoiceName': shop.invoiceName,
        'carts': newCarts,
        'status': 1,
        'createdUserName': '食器センター',
        'updatedUserName': '食器センター',
        'updatedAt': DateTime.now(),
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      error = '注文に失敗しました';
    }
    return error;
  }

  Future<String?> ordered({
    OrderModel? order,
    List<CartModel>? carts,
    List<CartModel>? cartsWash,
  }) async {
    String? error;
    if (order == null) return '受注に失敗しました';
    if (carts == null) return '受注に失敗しました';
    if (carts.isEmpty) return '受注に失敗しました';
    if (cartsWash == null) return '受注に失敗しました';
    if (cartsWash.isEmpty) return '受注に失敗しました';
    try {
      List<Map> newCarts = [];
      List<CartModel> newCarts2 = [];
      for (CartModel cart in carts) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
          newCarts2.add(cart);
        }
      }
      for (CartModel cart in cartsWash) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
          newCarts2.add(cart);
        }
      }
      if (newCarts.isEmpty) {
        return '受注に失敗しました';
      }
      await _receiptPrint(
        shopName: order.shopName,
        carts: newCarts2,
        createdAt: order.createdAt,
      );
      orderService.update({
        'id': order.id,
        'carts': newCarts,
        'status': 1,
        'updatedUserName': '食器センター',
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = '受注に失敗しました';
    }
    return error;
  }

  Future<String?> reOrdered({
    OrderModel? order,
    List<CartModel>? carts,
  }) async {
    String? error;
    if (order == null) return '再受注に失敗しました';
    if (carts == null) return '再受注に失敗しました';
    if (carts.isEmpty) return '再受注に失敗しました';
    try {
      List<Map> newCarts = [];
      List<CartModel> newCarts2 = [];
      for (CartModel cart in carts) {
        if (cart.deliveryQuantity > 0) {
          newCarts.add(cart.toMap());
          newCarts2.add(cart);
        }
      }
      if (newCarts.isEmpty) {
        return '再受注に失敗しました';
      }
      await _receiptPrint(
        shopName: order.shopName,
        carts: newCarts2,
        createdAt: order.createdAt,
      );
      orderService.update({
        'id': order.id,
        'carts': newCarts,
        'status': 1,
        'updatedUserName': '食器センター',
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = '再受注に失敗しました';
    }
    return error;
  }

  Future<String?> cancel(OrderModel order) async {
    String? error;
    try {
      orderService.update({
        'id': order.id,
        'status': 9,
        'updatedUserName': '食器センター',
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      error = 'キャンセルに失敗しました';
    }
    return error;
  }

  Future initCarts() async {
    _carts = await cartService.get();
    notifyListeners();
  }

  Future addCarts(ProductModel product, int requestQuantity) async {
    await cartService.add(product, requestQuantity);
  }

  Future removeCart(CartModel cart) async {
    await cartService.remove(cart);
  }

  Future clearCart() async {
    await cartService.clear();
  }

  Future totalPrint({
    required List<ProductModel> products,
    required Map<String, int> totalMap,
  }) async {
    if (products.isEmpty) return;
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final productStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    List<pw.TableRow> tableRows = [];
    for (ProductModel product in products) {
      int total = 0;
      if (totalMap[product.number] != null) {
        total = totalMap[product.number]!;
      }
      tableRows.add(pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.TableBorder(
            bottom: pw.BorderSide(color: PdfColors.black),
          ),
        ),
        children: [
          pw.Text(product.number, style: productStyle),
          pw.Text(product.name, style: productStyle),
          pw.Text('$total${product.unit}', style: productStyle),
        ],
      ));
    }
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll57,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Table(
              columnWidths: {
                0: const pw.IntrinsicColumnWidth(),
                1: const pw.IntrinsicColumnWidth(),
                2: const pw.IntrinsicColumnWidth(),
              },
              children: tableRows,
            ),
          ],
        );
      },
    ));
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      format: PdfPageFormat.roll57,
      usePrinterSettings: true,
    );
  }

  Future _receiptPrint({
    String? shopName,
    List<CartModel>? carts,
    DateTime? createdAt,
  }) async {
    if (shopName == null) return;
    if (carts == null) return;
    if (carts.isEmpty) return;
    if (createdAt == null) return;
    final pdf = pw.Document();
    final font = await rootBundle.load(kPdfFontUrl);
    final ttf = pw.Font.ttf(font);
    final headerStyle = pw.TextStyle(
      font: ttf,
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    final shopStyle = pw.TextStyle(
      font: ttf,
      fontSize: 12,
    );
    final productStyle = pw.TextStyle(
      font: ttf,
      fontSize: 11,
    );
    final dateStyle = pw.TextStyle(
      font: ttf,
      fontSize: 10,
    );
    final signStyle = pw.TextStyle(
      font: ttf,
      fontSize: 8,
    );
    List<pw.TableRow> tableRows = [];
    for (CartModel cart in carts) {
      tableRows.add(pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.TableBorder(
            bottom: pw.BorderSide(color: PdfColors.black),
          ),
        ),
        children: [
          pw.Text(cart.number, style: productStyle),
          pw.Text(cart.name, style: productStyle),
          pw.Text('${cart.deliveryQuantity}${cart.unit}', style: productStyle),
        ],
      ));
    }
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.roll57,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(child: pw.Text('納品書', style: headerStyle)),
            pw.SizedBox(height: 4),
            pw.Text('$shopName　様', style: shopStyle),
            pw.SizedBox(height: 8),
            pw.Table(
              columnWidths: {
                0: const pw.IntrinsicColumnWidth(),
                1: const pw.IntrinsicColumnWidth(),
                2: const pw.IntrinsicColumnWidth(),
              },
              children: tableRows,
            ),
            pw.SizedBox(height: 8),
            pw.Text('注文日時', style: dateStyle),
            pw.Text(
              dateText('yyyy年MM月dd日 HH:mm', createdAt),
              style: dateStyle,
            ),
            pw.SizedBox(height: 4),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
              ),
              width: double.infinity,
              height: 60,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('店舗受取サイン', style: signStyle),
              ),
            ),
            pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  left: pw.BorderSide(color: PdfColors.black),
                  right: pw.BorderSide(color: PdfColors.black),
                  bottom: pw.BorderSide(color: PdfColors.black),
                ),
              ),
              width: double.infinity,
              height: 60,
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text('品質確認済', style: signStyle),
              ),
            ),
          ],
        );
      },
    ));
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      format: PdfPageFormat.roll57,
      usePrinterSettings: true,
    );
  }

  Future csvDownload() async {
    final fileName = '${dateText('yyyyMMddHHmmss', DateTime.now())}.csv';
    List<String> header = [
      '注文日時',
      '注文番号',
      '発注元店舗番号',
      '発注元店舗名',
      '商品番号',
      '商品名',
      '単価',
      '単位',
      '希望数量',
      '納品数量',
      '合計金額',
      'ステータス',
    ];
    List<OrderModel> orders = await orderService.selectList(
      shopNumber: searchShop,
      searchStart: searchStart,
      searchEnd: searchEnd,
    );
    List<List<String>> rows = [];
    for (OrderModel order in orders) {
      if (order.status != 1) {
        continue;
      }
      for (CartModel cart in order.carts) {
        List<String> row = [];
        row.add(dateText('yyyy/MM/dd HH:mm', order.createdAt));
        row.add(order.number);
        row.add(order.shopNumber);
        row.add(order.shopName);
        row.add(cart.number);
        row.add(cart.name);
        row.add('${cart.price}');
        row.add(cart.unit);
        row.add('${cart.requestQuantity}');
        row.add('${cart.deliveryQuantity}');
        int totalPrice = cart.price * cart.deliveryQuantity;
        row.add('$totalPrice');
        row.add(order.statusText());
        rows.add(row);
      }
    }
    String csv = const ListToCsvConverter().convert(
      [header, ...rows],
    );
    String bom = '\uFEFF';
    String csvText = bom + csv;
    csvText = csvText.replaceAll('[', '');
    csvText = csvText.replaceAll(']', '');
    AnchorElement(href: 'data:text/plain;charset=utf-8,$csvText')
      ..setAttribute('download', fileName)
      ..click();
  }
}
