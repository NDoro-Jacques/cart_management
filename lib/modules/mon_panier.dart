import 'package:e_commerce_app/config/dbhelper.dart';
import 'package:e_commerce_app/models/panier_model.dart';
import 'package:e_commerce_app/services/panier_service.dart';
import 'package:e_commerce_app/widgets/panier_card.dart';
import 'package:e_commerce_app/widgets/total_panier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonPanier extends StatefulWidget {
  const MonPanier({Key? key}) : super(key: key);

  @override
  State<MonPanier> createState() => _MonPanierState();
}

class _MonPanierState extends State<MonPanier> {
  late final DBHelper dbHelper = DBHelper();
  List<Panier> _produitsARetirer = [];

  @override
  void initState() {
    super.initState();
    context.read<PanierService>().recupererContenuDuPanier();
  }

  @override
  Widget build(BuildContext context) {
    final panierService = Provider.of<PanierService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close),
        ),
        centerTitle: true,
        title: Consumer<PanierService>(
          builder: (context, panierService, child) {
            return Text(
              'Mon panier (${panierService.paniers.length})',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            );
          },
        ),
        actions: [
          GestureDetector(
            child: IconButton(
                onPressed: () =>
                    panierService.retirerProduits(_produitsARetirer),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFFE3E3E3),
        ),
        child: Consumer<PanierService>(
          builder: (context, panierService, child) {
            return panierService.paniers.isEmpty
                ? Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 30,
                        ),
                        Text('Continuez vos achats')
                      ],
                    ),
                  )
                : Container(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: panierService.paniers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PanierCard(
                            panier: panierService.paniers[index],
                            panierService: panierService,
                            dbHelper: dbHelper,
                            produitsARetirer: _produitsARetirer,
                            index: index);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                    ),
                  );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          height: 73,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TotalPanier(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: CupertinoButton(
                  color: Colors.deepOrange,
                  onPressed: () => print("Commander"),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Commander',
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
