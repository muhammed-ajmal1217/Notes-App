class NoteModel{
  String?id;
  String? title;
  String? description;

  NoteModel({
   this.id,
    this.title,
    this.description,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json){
    return NoteModel(
      id: json['id'],
      title: json['title'],
      description: json['description']
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["title"]=this.title;
    data["description"]=this.description;
    data["id"]=this.id;
    return data;
  }
}