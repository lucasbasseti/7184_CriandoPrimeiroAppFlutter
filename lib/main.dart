import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(App());

// Stateless é um Widget SEM estado.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Sempre vai retornar o MaterialApp é a casa da aplicação.
    // No Flutter a sintaxe do layout é declarativa é tudo junto.
    return MaterialApp(
      title: 'Todo App',

      // Não exibir o banner debug na aplicação.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // paleta de cores do Flutter.
        primarySwatch: Colors.blueGrey,
      ),
      // Página Inicial.
      home: HomePage(), 
    );
  }
}

// Stateful é um Widget COM estado. (Página Inicial).
class HomePage extends StatefulWidget {

  var items = new List<Item>();

  HomePage() {
    items = [];
    
    // items.add(Item(title: "Item 1", done: false));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Server para controlar o TextFormField, para pegar as informações digitadas nele.
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.text = "";
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

 // Sintaxe de um método async no flutter usa a palavra chave Future, async e await. 
  Future load() async {

    // Obtém a instância do SharedPreferences.
    var prefs = await SharedPreferences.getInstance();

    // Obtém o valor da chave data que está salva no SharedPreferences.
    var data = prefs.getString('data');

    if (data != null) {

      // Transforma em um objeto Iterable para ser possivel interar sobre esse objeto.
      Iterable decoded = jsonDecode(data);

      // Percorre utilizando o map o decoded é obtém os objetos e converte de json para Item utilizando o Item.fromJson
      // para converter o objeto json para um objeto do tipo Item.
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

      // Salva no State a lista de items.
      setState(() {
        widget.items = result;
      });
    }

  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  // O Contrutor só é chamado uma única vez no bootstrap(start) da aplicação.
  _HomePageState(){

    // Carrega a lista de itens salvas no shared_preferences.
    load();
  }

  // Toda vez que o flutter atualiza a arvore de widget ele chama novamente
  // esse metodo build.
  @override
  Widget build(BuildContext context) {
    // Scaffold representa o esqueleto da página.
    return Scaffold(
      appBar: AppBar(
        //title: Text("Todo List"),
        title: TextFormField(
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      /* body: Container(
        child: Center(
          child: Text("Olá mundo"),
        ),
      ), */
      // ListView.builder carrega os itens sobe-demanda, melhorando a performace.
      body: ListView.builder(
          itemCount: widget.items.length,

          // Metodo para dizer ao ListView como construir a lista.
          itemBuilder: (BuildContext ctxt, int index) {
            final item = widget.items[index];

            return Dismissible(
              key: Key(item.title),
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  // print exibe no terminal.
                  //print(value);

                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              background: Container(
                color: Colors.red.withOpacity(0.2),
                child: Text("Excluir"),
              ),
              onDismissed: (direction) {
                //print(direction);
                remove(index);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
