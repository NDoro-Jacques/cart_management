import 'package:e_commerce_app/config/dbhelper.dart';
import 'package:e_commerce_app/models/panier_model.dart';
import 'package:e_commerce_app/services/panier_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PanierCard extends StatefulWidget {
  const PanierCard({Key? key,
    required this.panier,
    required this.panierService,
    required this.dbHelper,
    required this.produitsARetirer,
    required this.index}) : super(key: key);

  final Panier panier;
  final PanierService panierService;
  final DBHelper dbHelper;
  final List<Panier> produitsARetirer;
  final int index;

  @override
  State<PanierCard> createState() => _PanierCardState();
}

class _PanierCardState extends State<PanierCard> {
  bool _estSelectionne = false;
  @override
  Widget build(BuildContext context) {
    Panier produitAjoute = widget.panierService.paniers[widget.index];
    return Container(
      height: 84,
      // color: Colors.white,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  value: _estSelectionne,
                  onChanged: (value) {
                    setState(() {
                      _estSelectionne = value!;
                      if (value &&
                          !widget.produitsARetirer.contains(produitAjoute)) {
                        widget.produitsARetirer.add(produitAjoute);
                        _estSelectionne = !!value;
                      }
                    });
                  }),
              Container(
                height: 68,
                width: 68,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(
                  produitAjoute.image,
                  width: 92,
                  height: 92,
                  loadingBuilder: (context, child, loader) {
                    if (loader == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  frameBuilder: (context, child, frame, _) => child
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 150),
                    child: Text(
                      produitAjoute.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '${produitAjoute.price}',
                    maxLines: 2,
                    style: const TextStyle(
                        color: Color(0xff3c3c3c),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          Consumer<PanierService>(
            builder: (context, panierService, child) {
              int quantite = produitAjoute.quantity;
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => {
                      if (quantite > 1)
                        {
                          widget.panierService.decrementerQuantite(
                              produitAjoute.id),
                          widget.dbHelper
                              .mettreAJourQuantite(
                              Panier(
                              id: produitAjoute.id,
                              title: produitAjoute.title,
                              price: produitAjoute.price,
                              description: produitAjoute.description,
                              category: produitAjoute.category,
                              image: produitAjoute.image,
                              quantity: produitAjoute.quantity,
                          )
                          )
                              .then((value) {
                            setState(() {
                              widget.panierService.soustrairePrixTotal(
                                  produitAjoute.price);
                            });
                          })
                        }
                    },
                    child: Container(
                        height: 20,
                        width: 22,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xffEBE8E8))),
                        child: const Icon(
                          FontAwesomeIcons.minus,
                          color: Color(0xff707070),
                          size: 15,
                        )),
                  ),
                  const SizedBox(width: 8),
                  Text(quantite.toString()),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => {
                      widget.panierService.incrementerQuantite(produitAjoute.id),
                      widget.dbHelper
                          .mettreAJourQuantite(
                          Panier(
                            id: produitAjoute.id,
                            title: produitAjoute.title,
                            price: produitAjoute.price,
                            description: produitAjoute.description,
                            category: produitAjoute.category,
                            image: produitAjoute.image,
                            quantity: produitAjoute.quantity,
                          )
                      )
                          .then((value) {
                        setState(() {
                          widget.panierService
                              .additionnerPrixTotal(produitAjoute.price);
                        });
                      })
                    },
                    child: Container(
                      // padding: const EdgeInsets.all(10),
                        height: 20,
                        width: 22,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: const Color(0xffEBE8E8))),
                        child: const Icon(
                          FontAwesomeIcons.add,
                          color: Color(0xff707070),
                          size: 15,
                        )),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
