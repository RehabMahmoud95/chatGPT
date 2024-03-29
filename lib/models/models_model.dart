class ModelsModel {
  final String id;
  final int created;
  final String root;

  ModelsModel({required this.id, required this.created, required this.root});

  factory ModelsModel.fromJson(Map<String, dynamic> json) {
    return ModelsModel(
        id: json["id"], created: json["created"], root: json["object"]);
  }



  static List<ModelsModel> modelsFromSnapshot(List modelSnapshot) {
    return modelSnapshot.map((e) => ModelsModel.fromJson(e)).toList();
  }
}
