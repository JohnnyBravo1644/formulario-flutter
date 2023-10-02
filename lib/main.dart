import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulário Flutter'),
        ),
        body: Formulario(),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  DateTime? dataNascimento;
  TextEditingController cidadeController = TextEditingController();
  TextEditingController paisController = TextEditingController();
  TextEditingController topicosController = TextEditingController();
  TextEditingController idiomaController = TextEditingController();
  String? notificacoesPorEmail;
  File? _image;
  bool _podeAtualizar = false;

  void _atualizarBotao() {
    final form = _formKey.currentState;
    if (form != null) {
      setState(() {
        _podeAtualizar = form.validate();
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua data de nascimento';
    }
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Por favor, insira uma data válida';
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dataNascimento)
      setState(() {
        dataNascimento = picked;
      });
  }

  Future<void> _selecionarImagem() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImageWidget() {
    if (_image != null) {
      return Image.file(
        _image!,
        height: 100,
        width: 100,
      );
    } else {
      return ElevatedButton(
        onPressed: _selecionarImagem,
        child: Text('Selecionar Foto de Perfil'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _atualizarBotao,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildImageWidget(),
            TextFormField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome Completo'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                return null;
              },
            ),
            if (nomeController.text.isEmpty)
              Text(
                'Por favor, insira seu nome',
                style: TextStyle(color: Colors.red),
              ),
            GestureDetector(
              onTap: () => _selecionarData(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                      text: dataNascimento == null
                          ? ''
                          : "${dataNascimento!.toLocal()}".split(' ')[0]),
                  decoration: InputDecoration(labelText: 'Data de Nascimento'),
                  validator: _validateDate,
                ),
              ),
            ),
            if (_validateDate(dataNascimento.toString()) != null)
              Text(
                'Por favor, insira uma data válida',
                style: TextStyle(color: Colors.red),
              ),
            TextFormField(
              controller: cidadeController,
              decoration: InputDecoration(labelText: 'Cidade'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira sua cidade';
                }
                return null;
              },
            ),
            TextFormField(
              controller: paisController,
              decoration: InputDecoration(labelText: 'País de Residência'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira seu país de residência';
                }
                return null;
              },
            ),
            TextFormField(
              controller: topicosController,
              decoration: InputDecoration(labelText: 'Tópicos de Interesse (Opcional)'),
            ),
            TextFormField(
              controller: idiomaController,
              decoration: InputDecoration(labelText: 'Idioma Preferido (Opcional)'),
            ),
            DropdownButtonFormField<String>(
              value: notificacoesPorEmail,
              decoration: InputDecoration(labelText: 'Notificações por E-mail'),
              items: ['Sim', 'Não'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  notificacoesPorEmail = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, escolha uma opção';
                }
                return null;
              },
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _podeAtualizar
                      ? () {
                    // Função de atualizar
                  }
                      : null,
                  child: Text('Atualizar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Aqui você pode enviar os dados para onde quer que precise
                      // Exemplo: enviar para um banco de dados, enviar por e-mail, etc.
                    }
                  },
                  child: Text('Enviar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
