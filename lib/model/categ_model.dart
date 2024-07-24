class CategoryModel {
  late String nom, image, id;

  CategoryModel({required this.nom, required this.image, required this.id});

  CategoryModel.fromJson(Map<String, dynamic> map, String id) {
    nom = map['nom'] ?? '';
    image = map['image'] ?? '';
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'image': image,
      'id': id,
    };
  }
  toJson2(){
    return {
      'nom': nom,
      'image': image,
    };
  }
}
