import 'package:e_commerce_app/config/dbhelper.dart';
import 'package:e_commerce_app/models/panier_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PanierService with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _compteur = 0;
  int _quantite = 1;
  double _prixTotal = 0.0;

  int get compteur => _compteur;
  int get quantite => _quantite;
  double get prixTotal => _prixTotal;

  List<Panier> paniers = [];

  Future<List<Panier>> recupererContenuDuPanier() async {
    paniers = await dbHelper.recupererProduitsDuPanier();
    notifyListeners();

    return paniers;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('nombre_livres', _compteur);
    prefs.setInt('quantite_livre', _quantite);
    prefs.setDouble('prix_total', _prixTotal);

    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _compteur = prefs.getInt('nombre_livres') ?? 0;
    _quantite = prefs.getInt('quantite_livre') ?? 1;
    _prixTotal = prefs.getDouble('prix_total') ?? 0;
  }

  void incrementer() {
    _compteur++;
    _setPrefsItems();
    notifyListeners();
  }

  void decrementer() {
    _compteur--;
    _setPrefsItems();
    notifyListeners();
  }

  int recupererCompteur() {
    _getPrefsItems();
    return _compteur;
  }

  void incrementerQuantite(int id) {
    final index = paniers.indexWhere((element) => element.id == id);
    paniers[index].quantity = paniers[index].quantity + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void decrementerQuantite(int id) {
    final index = paniers.indexWhere((element) => element.id == id);
    var quantiteActuel = paniers[index].quantity;
    if (quantiteActuel <= 1) {
      quantiteActuel = 1;
    } else {
      paniers[index].quantity = quantiteActuel - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void retirerProduits(List<Panier> paniers) {
    var livresARetirer = paniers.toList();

    livresARetirer.forEach((panier) {
      var index = paniers.indexWhere((element) => livresARetirer.contains(element));
      paniers.removeAt(index);
      dbHelper.supprimerProduitDuPanier(panier.id);
      reCalculerPrixTotalApresSuppression(panier.price, panier.quantity);
      recupererContenuDuPanier();
      decrementer();
    });

    _setPrefsItems();
    notifyListeners();
  }

  void viderPanier() {
    paniers.clear();
    dbHelper.viderPanier();
    _prixTotal = 0;
    recupererContenuDuPanier();
    _compteur = 0;

    _setPrefsItems();
    notifyListeners();
  }

  int recupererQuantite(int quantite) {
    _getPrefsItems();
    return _quantite;
  }

  void additionnerPrixTotal(double prixLivre) {
    _prixTotal = _prixTotal + prixLivre;
    _setPrefsItems();
    notifyListeners();
  }

  void calculerPrixTotal(double prixLivre, int quantite) {
    _prixTotal = _prixTotal + (prixLivre * quantite);
    _setPrefsItems();
    notifyListeners();
  }

  void reCalculerPrixTotalApresSuppression(double prixLivre, int quantite) {
    _prixTotal = _prixTotal - (prixLivre * quantite);
    _setPrefsItems();
    notifyListeners();
  }

  void soustrairePrixTotal(double prixLivre) {
    _prixTotal = _prixTotal - prixLivre;
    _setPrefsItems();
    notifyListeners();
  }

  double recupererPrixTotal() {
    _getPrefsItems();

    return _prixTotal;
  }

}
