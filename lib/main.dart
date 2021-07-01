import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_hands_on/stores/product_list_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hands_on/components/product_card.dart';
import 'package:flutter_hands_on/pages/product_detail.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MultiProvider(
    // MultiProviderは複数のChangeNotifierProviderを格納できる
    // providersにChangeNotifierProviderの配列を指定
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductListStore(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // addPostFrameCallbackは、initStateが呼ばれた後に一度のみ実行されるコールバック
    // ウィジェットの描画を行う際、最初に**一回だけ**実行したい処理を記述する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ビルドが終わったら、context.readでProductListStoreを見に行く？
      // addPostFrameCallback()に渡されたコールバック関数の中ではBuildContextへの参照を得られる
      final store = context.read<ProductListStore>();
      if (store.products.isEmpty) {
        store.fetchNextProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        // Appのroutesに遷移したいwidgetの情報を格納する
        // { ルーティング名: (context) => 表示したいウィジェット, }という形式で記述
        ProductDetail.routeName: (context) => ProductDetail(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SUZURI"),
      ),
      body: _productsList(context),
    );
  }

  Widget _productsList(BuildContext context) {
    // storeの参照を取得
    // watchでStoreに変更があったらwidgetに反映される
    final store = context.watch<ProductListStore>();
    final products = store.products;
    if (products.isEmpty) {
      return Center(child: Text("ねえよ"));
    }
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            // color: Colors.grey,
            margin: EdgeInsets.all(16),
            // child: Image.network(products[index].sampleImageUrl),
            child: ProductCard(product: products[index]),
          );
        },
      ),
    );
  }
}