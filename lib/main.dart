import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              // criar a validacao do e-mail e senha

              decoration: InputDecoration(hintText: 'Email'),
            ),
            const TextField(
              decoration: InputDecoration(hintText: 'Senha'),
              obscureText: true,
            ),
            ElevatedButton(
              child: const Text('Entrar'),
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
    );
  }
}

class CatalogItem {
  final String name;
  final String color;
  final double value;

  CatalogItem({required this.name, required this.color, required this.value});
}

class CatalogPage extends StatefulWidget {
  @override
  _CatalogPageState createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final cart = ValueNotifier<List<CatalogItem>>([]);
  final catalogItems = [
    CatalogItem(name: 'Item 1', color: 'Azul', value: 10),
    CatalogItem(name: 'Item 2', color: 'Vermelho', value: 20),
    CatalogItem(name: 'Item 3', color: 'Verde', value: 30),
    // adicione mais itens conforme necessário
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                            fontSize: 8,
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
      body: ListView.builder(
        itemCount: catalogItems.length,
        itemBuilder: (context, index) {
          final item = catalogItems[index];
          return ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: colorFromString(item.color),
            ),
            title: Text(item.name),
            // subtitle: Text('Cor: ${item.color}'),
            trailing: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => cart.value = [...cart.value, item],
            ),
          );
        },
      ),
    );
  }
}

Color colorFromString(String colorName) {
  switch (colorName) {
    case 'Azul':
      return Colors.blue;
    case 'Vermelho':
      return Colors.red;
    case 'Verde':
      return Colors.green;
    // adicione mais cores conforme necessário
    default:
      return Colors.black; // cor padrão caso o nome da cor não seja reconhecido
  }
}

class CartPage extends StatelessWidget {
  final ValueNotifier<List<CatalogItem>> cart;

  CartPage(this.cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: cart,
        builder: (context, List<CatalogItem> value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(value[index].name),
                subtitle: Text('Cor: ${value[index].color}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    cart.value = List.from(cart.value)..removeAt(index);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: cart,
        builder: (context, List<CatalogItem> value, _) {
          final totalValue = value.fold<double>(
              0, (previousValue, item) => previousValue + item.value);
          return Text(
              'Total de itens no carrinho: ${value.length}, Valor total: \$${totalValue.toStringAsFixed(2)}');
        },
      ),
    );
  }
}
