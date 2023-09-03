import 'package:e_commerce_app/services/panier_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalPanier extends StatefulWidget {
  TotalPanier({Key? key}) : super(key: key);

  @override
  _TotalPanierState createState() => _TotalPanierState();
}

class _TotalPanierState extends State<TotalPanier> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PanierService>(
        builder: (BuildContext context, panierService, Widget? child) {
      double prixTotal = 0;

      for (var panier in panierService.paniers) {
        prixTotal = (panier.price * panier.quantity) + (prixTotal ?? 0);
      }

      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<PanierService>(builder: (context, panierService, child) {
              return Text(
                panierService.recupererPrixTotal().toStringAsFixed(2),
                maxLines: 2,
                style: const TextStyle(
                    color: Color(0xff3c3c3c),
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              );
            }),
            const Text(
              "Montant total",
              maxLines: 2,
              style: TextStyle(
                  color: Color(0xff707070),
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}
