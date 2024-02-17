// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryModel {
  String? name;
  CategoryModel({
    this.name,
  });

  List<CategoryModel> get categories {
    return [
      CategoryModel(name: "Kidnapping"),
      CategoryModel(name: "Military Base Attack"),
      CategoryModel(name: "Oil Well Vandalization"),
      CategoryModel(name: "Police Barracks Attack"),
    ];
  }
}
