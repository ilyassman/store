import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:store/model/cart_product_model.dart';

class CartDatabaseHelper {
  CartDatabaseHelper._();
  static final CartDatabaseHelper db = CartDatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cart_product.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE cart_product ('
            'productId TEXT NOT NULL,'
            'name TEXT NOT NULL,'
            'image TEXT NOT NULL,'
            'price TEXT NOT NULL,'
            'quantity INTEGER NOT NULL'
            ')');
      },
    );
  }

  Future<List<CartProductModel>> getAllProduct() async {
    var dbClient = await database;

    List<Map> maps = await dbClient.query('cart_product');

    List<CartProductModel> list = maps.isNotEmpty
        ? maps.map((product) => CartProductModel.fromJson(product)).toList()
        : [];

    return list;
  }

  Future<void> insert(CartProductModel model) async {
    var dbClient = await database;
    await dbClient.insert('cart_product', model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  updateProduct(CartProductModel model) async {
    var dbClient = await database;
    await dbClient.update('cart_product', model.toJson(),
        where: 'productId=?', whereArgs: [model.productId]);
  }

  deletcart() async {
    var dbClient = await database;
    await dbClient.delete('cart_product');
  }

  deletProduct(String productId) async {
    var dbClient = await database;
    await dbClient
        .delete('cart_product', where: 'productId=?', whereArgs: [productId]);
  }
}
