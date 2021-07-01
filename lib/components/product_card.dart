import 'package:flutter/material.dart';
import 'package:flutter_hands_on/models/product.dart';
import 'package:flutter_hands_on/pages/product_detail.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({ this.product });

  @override
  Widget build(BuildContext context) {
    // GestureDetectorは色んな操作を管理してくれる便利widget
    // 今回は**タップしたら**の動作を設定したい
    return GestureDetector(
      onTap: () async {
        // print('tapped');
        Navigator.of(context).pushNamed(
          ProductDetail.routeName,
          arguments: this.product,
        );
      },
      // Containerをラップする
      child: Container(
        margin: EdgeInsets.all(16),
        // 縦に並べるWidget
        child: Column(
          // Widgetのリストを渡す。上から表示したい順に配置していく
          children: <Widget>[
            Image.network(product.sampleImageUrl),
            // widgetのサイズを固定するためにwidget
            // 40に固定している
            SizedBox(
              height: 40,
              child: Text(product.title), // 商品名
            ),
            Text('${product.price.toString()}円'),
          ],
        )
      )
    );
  }
}