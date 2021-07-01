import 'package:flutter/material.dart';
import 'package:flutter_hands_on/models/product.dart';
import 'package:flutter_hands_on/requests/product_request.dart';

// httpって変数名でインポート
import 'package:http/http.dart' as http;

// ChangeNotifierからの変更通知でなんかできるらしい
class ProductListStore extends ChangeNotifier {
  // 管理する商品リスト Productモデル のリスト
  List<Product> _products = [];
  // 外部にgetterのみ公開
  List<Product> get products => _products;

  // リクエスト受信中は再描画しないようにする
  bool _isFetching = false;
  bool get isFetching => _isFetching;

  // Storeに変更を要求するためのインターフェース
  fetchNextProducts() async {
    if (_isFetching) { return; }
    _isFetching = true;
    // ProductRequestの初期化
    final request = ProductRequest(
      client: http.Client(),
      offset: _products.length,
    );

    final products = await request.fetch().catchError((e) {
      _isFetching = false;
    });
    // リクエスト完了後、取得でき・・・できなくてもここに来るんじゃない？
    // 取得できたのをリストに突っ込んで、
    _products.addAll(products);
    _isFetching = false;
    // 変更を通知する？
    notifyListeners();
  }
}