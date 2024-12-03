class Coffee {
  String? title;
  String? description;
  List<String>? ingredients;
  String? image;
  int? id;

  Coffee({this.title, this.description, this.ingredients, this.image, this.id});

  Coffee.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    ingredients = json['ingredients'].cast<String>();
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['ingredients'] = this.ingredients;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}