import 'package:flutter/material.dart';
import 'package:flutter_hands_on/models/product.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    // contextには遷移時に格納したデータが乗ってくる
    // 明示的にProduct型を指定してあげる必要があるんだぜ
    final Product product = ModalRoute.of(context).settings.arguments;

    // Scaffoldは新しい画面を返す
    return Scaffold(
      appBar: AppBar(
        title: Text('詳細でござい'),
      ),
      body: _body(context, product),
      // Container(
      //   child: Center(
      //     child: Text(product.title,)
      //   )
      // )
    );
  }

  Widget _body(BuildContext context, Product product) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Center(
            child: Image.network(product.sampleImageUrl),
          ),
          Text(
            product.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(product.item.humanizeName),
          Text('${product.price.toString()}円'),
          Text('作った人: ${product.material.user.name}'),
          product.material.description.isEmpty
            ? Container()
            : _descriptionSection(context, product)
        ]
      )
    );
  }

  Widget _descriptionSection(BuildContext context, Product product) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Text(
            'itemの説明',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.0),
            child: Text(product.material.description),
          ),
        ]
      )
    );
  }
}