import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _StatusBanco = '';

  ///Criando e recuperando DB.
  Future<Database> _RecuperarBancoDeDados() async {

    ///Busca o caminho de acordo com o dispositivo IOS/Android
    var vCaminho = await getDatabasesPath();
   String vCaminhoBanco =  join(vCaminho, 'dados.db') ; ///Concateno com o caminho retornado o nome do meu Banco a ser criado..



    ///OpenDatabase cria o Banco...
   var vBanco = await openDatabase(
       vCaminhoBanco, ///Caminho do banco.
        version: 1, ///versão para meu controle interno...
        onCreate: (Database DadosDoMeuBanco, int VersaoRecenteDoMeuBanco) {
         ///Crio as tabelas
          DadosDoMeuBanco.execute('CREATE TABLE USUARIOS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NOME VARCHAR(60), IDADE INTEGER)');

        });

   print('Status DB: ' + vBanco.isOpen.toString());

   return vBanco;
  }


  void _Inserir() async{

    Database vBanco = await _RecuperarBancoDeDados();

    Map<String, dynamic> vDados = {
      'NOME': 'USUÁRIO FIXO',
      'IDADE': 23
    };

    ///Passo o nome da tabela e um MAP com os dados... o método me retorna o número do ID inserido...
   int vIdInserido = await vBanco.insert('USUARIOS', vDados, conflictAlgorithm: ConflictAlgorithm.replace,);


   print("Registro Inserido:" + vIdInserido.toString());

  }



  void _Select() async {
    Database vBanco = await _RecuperarBancoDeDados();

    /// Método rawQuery recebe um SLQ e retona uma lista com os valores..
    List vListaDados = await vBanco.rawQuery('SELECT * FROM  USUARIOS');

    for(var i=0; i < vListaDados.length; i++){
       print("ID: " + vListaDados[i]["ID"].toString());
       print("NOME: " + vListaDados[i]["NOME"]);
       print("IDADE: " + vListaDados[i]["IDADE"].toString());
    }

  }


  ///Minha telaaaa
  @override
  Widget build(BuildContext context) {

    return Column(
        children: <Widget>[

          Center(
              child: Text("Verifique os Logs"),
              ),

          ElevatedButton(
            child: Text("Inserir"),
              onPressed: _Inserir,
          ),

          ElevatedButton(
            child: Text("Select"),
            onPressed: _Select,
          ),

          ElevatedButton(
            child: Text("Delete"),
            onPressed: _Select,
          ),



        ],


    );
  }
}
