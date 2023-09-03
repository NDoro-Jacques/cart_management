import 'dart:io' as io;

import 'package:e_commerce_app/models/panier_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'e_commerce_app.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreer);

    return db;
  }

  _onCreer(Database db, int version) async {
    await db.execute(
        'CREATE TABLE panier(id INTEGER PRIMARY KEY, title VARCHAR, price DOUBLE, description VARCHAR, category VARCHAR, image VARCHAR, quantity INTEGER)');
  }

  Future<Panier> inserer(Panier panier) async {
    var dbClient = await database;
    await dbClient!.insert('panier', panier.toMap());

    return panier;
  }

  Future<List<Panier>> recupererProduitsDuPanier() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('panier');

    return queryResult.map((result) => Panier.fromMap(result)).toList();
  }

  Future<Panier> mettreAJourQuantite(Panier panier) async {
    var dbClient = await database;

    await dbClient!.update('panier', panier.toMap(),
        where: "id = ?", whereArgs: [panier.id]);

    return panier;
  }

  Future<int> supprimerProduitDuPanier(int id) async {
    var dbClient = await database;

    return await dbClient!.delete('panier', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> viderPanier() async {
    var dbClient = await database;

    return await dbClient!.delete('panier');
  }

  Future<List<Map<String, Object?>>> verifierExistenceProduit(int idPanier) async {
    var dbClient = await database;

    final queryResult = await dbClient!
        .query('panier', where: "id = ?", whereArgs: [idPanier], limit: 1);

    return queryResult;
  }
}
