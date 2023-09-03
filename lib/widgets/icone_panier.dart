import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:e_commerce_app/modules/mon_panier.dart';
import 'package:e_commerce_app/services/panier_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IconePanier extends StatefulWidget {
  IconePanier({Key? key}) : super(key: key);

  @override
  _IconePanierState createState() => _IconePanierState();
}

class _IconePanierState extends State<IconePanier> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PanierService>(
      builder: (context, panierService, child) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MonPanier(),
          )),
          child: CircleAvatar(
            backgroundColor: Colors.deepOrange,
              child: badges.Badge(
                badgeContent: Consumer<PanierService>(
                  builder: (context, panierService, child) {
                    return Text(
                        panierService.recupererCompteur().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
              )),
        );
      },
    );
  }
}
