import 'package:flutter/material.dart';

void main() {
  runApp(Biribim());
}

class Biribim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.indigo[400],
          accentColor: Colors.purpleAccent[700],
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.indigo[400],
              textTheme: ButtonTextTheme.primary
          )
      ),
      home: ListaTransferencia(),
    );
  }
}

class FormularioTransferencia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormularioTransferenciaState();
  }
}

class FormularioTransferenciaState extends State<FormularioTransferencia> {
  final TextEditingController _controladorCampoMovimentacao = TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();
  final TextEditingController _controladorCampoData = TextEditingController();
  final TextEditingController _controladorCampoDescricao = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Movimentação'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controlador: _controladorCampoMovimentacao,
              rotulo: 'Tipo de Movimentação',
            ),

            Editor(
              controlador: _controladorCampoValor,
              rotulo: 'Valor',
              dica: '0.00',
              icone: Icons.monetization_on,
            ),
            Editor(
              controlador: _controladorCampoData,
              rotulo: 'Data',
              dica: 'DD/MM/YYYY',
            ),
            Editor(
              controlador: _controladorCampoDescricao,
              rotulo: 'Descrição',
              dica: 'Texto',
            ),
            RaisedButton(
              child: Text('Confirmar'),
              onPressed: () => _criaTransferencia(context),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(BuildContext context) {
    final String movimentacao = _controladorCampoMovimentacao.text;
    final double valor = double.tryParse(_controladorCampoValor.text);
    final String data = _controladorCampoData.text;
    final String descricao = _controladorCampoDescricao.text;
    if (movimentacao != null && valor != null) {
      final transferenciaCriada = Transferencia(
          valor, movimentacao,data, descricao);
      debugPrint('Criar Movimentação');
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  String rotulo;
  String dica;
  final IconData icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: Icon(icone) != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = List();

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movimentações'),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final Future<Transferencia> future =
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            Future.delayed(Duration(seconds: 1), () {
              debugPrint('chegou no then do future');
              debugPrint('$transferenciaRecebida');
              if (transferenciaRecebida != null) {
                setState(() {
                  widget._transferencias.add(transferenciaRecebida);
                });
              }
            });
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia transferencia;

  ItemTransferencia(this.transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(transferencia.movimentacao.toString()),
        subtitle: Text(transferencia.Descricao()),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final String movimentacao;
  final String data;
  final String descricao;

  Transferencia(this.valor, this.movimentacao, this.data, this.descricao);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, movimentacao: $movimentacao, data: $data}';
  }

  String Descricao() {
    return 'Valor: $valor\n Data: $data\n Descrição: $descricao' ;

  }
}
