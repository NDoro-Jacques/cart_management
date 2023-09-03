import 'dart:developer';

import 'package:e_commerce_app/config/dbhelper.dart';
import 'package:e_commerce_app/models/panier_model.dart';
import 'package:e_commerce_app/services/panier_service.dart';
import 'package:e_commerce_app/services/produit_service.dart';
import 'package:e_commerce_app/widgets/icone_panier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PanierService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProduitService _produitService = ProduitService();
  int _counter = 0;
  List<dynamic> _products = [];
  bool _isLoading = false;
  late final DBHelper dbHelper;

  void _recupererProduits() async {
    setState(() => _isLoading = true);
    _produitService.recupererProduits().then((data) {
      setState(() {
        _products = data;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _recupererProduits();
  }

  @override
  Widget build(BuildContext context) {
    final panierService = Provider.of<PanierService>(context);

    Future<void> ajouterProduitAuPanier(dynamic produit, int quantite) async {
      Panier panier = Panier(
        id: produit['id'],
        title: produit['title'],
        price: produit['price'],
        description: produit['description'],
        category: produit['category'],
        image: produit['image'],
        quantity: quantite,
      );
      var produitExistant = await dbHelper.verifierExistenceProduit(panier.id);
      if (produitExistant.isNotEmpty) {
        int quantitePourProduit = produitExistant[0]['quantite'] as int;
        panier.quantity = quantitePourProduit++;
        panierService.incrementerQuantite(panier.id);
        dbHelper.mettreAJourQuantite(panier).then((value) {
          panierService.calculerPrixTotal(produit['price'], quantite);
        });
      } else {
        dbHelper.inserer(panier).then((value) {
          panierService.calculerPrixTotal(produit['price'], quantite);
          panierService.incrementer();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconePanier()],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFE3E3E3),
        ),
        child: SingleChildScrollView(
          child: GridView.count(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.7),
              crossAxisCount: 2,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
              children: _products.map((prod) {
                return GestureDetector(
                    onTap: () => {},
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 30, bottom: 10),
                      height: 500,
                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: <Widget>[
                          Image.network(prod['image'],
                              width: 92,
                              height: 92,
                              frameBuilder: (context, child, frame, _) => child,
                              errorBuilder: (context, child, _) => Image.asset(
                                    'assets/images/image_defaut.png',
                                    width: 92,
                                    height: 92,
                                  ),
                              loadingBuilder: (context, child, loader) {
                                if (loader == null) {
                                  return child;
                                }
                                return const SizedBox(
                                  height: 92,
                                  width: 92,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }),
                          const SizedBox(height: 18),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  prod['title']!.toString().trim(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Color(0xff121212),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "${prod['price']} \$",
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Color(0xff121212),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  ajouterProduitAuPanier(prod, 1);

                                  final snackBar = SnackBar(
                                    content:
                                        const Text('Produit ajouté au panier'),
                                    action: SnackBarAction(
                                      label: 'Fermer',
                                      onPressed: () {},
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Text(
                                      'Ajouter',
                                      style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              }).toList()),
        ),
      ),
    );
  }
}
