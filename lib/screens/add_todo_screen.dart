import 'package:flutter/material.dart';
import 'package:flutterversaoweb/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('ADICIONE')),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Titulo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Titulo está vazio';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Data',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Added null check
                      return 'Data está vazia';
                    }

                    // Verifica se a data está no formato correto (DD/MM/YYYY)
                    final RegExp dateRegExp = RegExp(
                      r'^\d{1,2}/\d{1,2}/\d{4}$',
                    );
                    if (!dateRegExp.hasMatch(value)) {
                      return 'Formato de data invalido. Use DD/MM/YYYY';
                    }

                    return null;
                  },
                  // Adicionar dentro do TextFormField do campo de data
                  onTap: () async {
                    // Esconde o teclado
                    FocusScope.of(context).requestFocus(FocusNode());

                    // Mostra o seletor de data
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      // No need for mounted check here as it's within the same async gap
                      setState(() {
                        _dateController.text =
                            "${picked.day}/${picked.month}/${picked.year}";
                      });
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Descrição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      // Added null check
                      return 'Descrição está vazia';
                    }
                    return null; // Added explicit null return
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width * 0.6, height * 0.06),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                onPressed: () async {
                  // Check validation first
                  if (_key.currentState?.validate() != true) {
                    // Simplified check
                    // Show error dialog (no async gap here)
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text(
                              'Error',
                              style: TextStyle(color: Colors.red),
                            ),
                            content: const Text('Check the inputs'),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Return',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                  } else {
                    // Validation passed, perform async operation
                    bool success = await todoProvider.insertData(
                      _titleController.text,
                      _descriptionController.text,
                      _dateController.text,
                    );

                    // IMPORTANT: Check if the widget is still mounted before using context
                    if (mounted) {
                      if (success) {
                        // Only proceed if insertion was successful
                        _titleController.clear();
                        _descriptionController.clear();
                        _dateController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarefa adicionada com sucesso!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context); // Safe to pop now
                      } else {
                        // Show error message if insertion failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to add todo. Please try again.',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text('Inserir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}