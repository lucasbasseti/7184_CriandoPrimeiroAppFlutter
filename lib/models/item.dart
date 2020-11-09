class Item {

  String title;
  bool done;

  // Contrutor no Dart essa sintaxe {} já passa os parâmetros no contrutor e atribui as propriedades.
  Item({this.title, this.done});

  // JSON to Dart.
  // https://javiercbk.github.io/json_to_dart/
  // { "title":"123", "done":true }

  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }

}