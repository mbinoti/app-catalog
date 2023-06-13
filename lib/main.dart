import 'dart:math';

import 'package:flutter/material.dart';

import 'catalog_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // adicone text welcome to the app
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              const TextField(
                decoration: InputDecoration(hintText: 'Email'),
              ),
              const TextField(
                decoration: InputDecoration(hintText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Enter'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CatalogPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final cart = ValueNotifier<List<CatalogItem>>([]);

  List<CatalogItem> catalogItems = List<CatalogItem>.generate(
    15,
    (i) => CatalogItem(
      name: [
        'Code Smell',
        'Control Flow',
        'Interpreter',
        'Recursion',
        'Sprint',
        'Heisenbug',
        'Spaghetti',
        'Hydra Code',
        'Off-By-One',
        'Scope',
        'Callback',
        'Closure',
        'Automata',
        'Bit Shift',
        'Currying',
      ][i],
      color: Colors.primaries[i % Colors.primaries.length],
      value: 10.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Catálogo'),
          actions: [
            ValueListenableBuilder(
              valueListenable: cart,
              builder: (context, List<CatalogItem> value, _) {
                return IconButton(
                  icon: Stack(
                    children: <Widget>[
                      const Icon(Icons.shopping_cart),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${value.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage(cart)),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: cart,
          builder: (BuildContext context, List<CatalogItem> value, child) {
            return ListView.builder(
              itemCount: catalogItems.length,
              itemBuilder: (BuildContext context, int index) {
                final item = catalogItems[index];
                bool isItemInCart = cart.value.contains(item);
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    color: item.color,
                  ),
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: isItemInCart
                        ? const Icon(Icons.shopping_cart)
                        : const Icon(Icons.add_shopping_cart),
                    onPressed: isItemInCart
                        ? null // Desativar o botão se o item já estiver no carrinho
                        : () {
                            value = List.from(value)..add(item);
                            cart.value = value;
                          },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final ValueNotifier<List<CatalogItem>> cart;

  CartPage(this.cart);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Carrinho'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8, // you can adjust this number to change the proportion
              child: ValueListenableBuilder(
                valueListenable: cart,
                builder: (BuildContext context, List<CatalogItem> value, _) {
                  return Container(
                    color: Colors.yellow,
                    child: ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text('- ${value[index].name}'),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Flexible(
              flex: 2, // you can adjust this number to change the proportion
              child: ValueListenableBuilder(
                valueListenable: cart,
                builder: (BuildContext context, List<CatalogItem> value, _) {
                  final totalValue = value.fold<double>(
                      0, (previousValue, item) => previousValue + item.value);

                  return Column(
                    children: [
                      // adicione uma linha divisoria com uma margem a direita e esquerda de 16.

                      const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 1,
                        thickness: 2,
                        color: Colors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            ' \$ ${totalValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              backgroundColor: Colors.yellow,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('BUY'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
