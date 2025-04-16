import 'package:flutter/material.dart';
import 'package:flutterversaoweb/model/todo_model.dart';
import 'package:flutterversaoweb/provider/todo_provider.dart';
import 'package:flutterversaoweb/screens/add_todo_screen.dart';
import 'package:flutterversaoweb/screens/edit_todo_screen.dart';
import 'package:provider/provider.dart';

class ShowTodoScreen extends StatelessWidget {
  const ShowTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final todoP = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('TAREFAS (Bloco de notas) \nDeslize para os lados.'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                useSafeArea: true,
                context: context,
                builder: (context) => DeleteTableDialog(todoP: todoP),
              );
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Color.fromARGB(255, 240, 72, 72),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<TodoProvider>(context, listen: false).selectData(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return todoProvider.todoItem.isNotEmpty
                    ? ListView.builder(
                      itemCount: todoProvider.todoItem.length,
                      itemBuilder: (context, index) {
                        final helperValue = todoProvider.todoItem[index];
                        return Dismissible(
                          key: ValueKey(helperValue.id),
                          background: const DismissBackGround(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            iconData: Icons.edit_outlined,
                          ),
                          secondaryBackground: const DismissBackGround(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            iconData: Icons.delete_forever_outlined,
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              return Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditTodoScreen(
                                        id: helperValue.id,
                                        title: helperValue.title,
                                        description: helperValue.description,
                                        date: helperValue.date,
                                      ),
                                ),
                              );
                            } else {
                              showDialog(
                                useSafeArea: true,
                                context: context,
                                builder:
                                    (context) =>
                                        DeleteDialog(helperValue: helperValue),
                              );
                            }
                          },
                          child: ListViewItemWidget(helperValue: helperValue),
                        );
                      },
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.indeterminate_check_box_outlined,
                            size: width * 0.2,
                          ),
                          const Text(
                            'Sua listinha está vazia.',
                            style: TextStyle(color: Colors.black, fontSize: 35),
                          ),
                        ],
                      ),
                    );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ListViewItemWidget extends StatelessWidget {
  const ListViewItemWidget({Key? key, required this.helperValue})
    : super(key: key);

  final TodoModel helperValue;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      color: const Color.fromARGB(255, 237, 247, 148),
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.01,
      ),
      elevation: 3,
      child: ListTile(
        style: ListTileStyle.drawer,
        title: Text(helperValue.title),
        subtitle: Text(
          helperValue.description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          helperValue.date,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DismissBackGround extends StatelessWidget {
  final Color color;
  final Alignment alignment;
  final IconData iconData;

  const DismissBackGround({
    Key? key,
    required this.color,
    required this.alignment,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      alignment: alignment,
      child: Icon(iconData, color: Colors.white),
      height: height * 0.02,
      width: width,
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key, required this.helperValue}) : super(key: key);

  final TodoModel helperValue;

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text('Deletar!'),
      content: const Text('Tem certeza que deseja excluir?'),
      actions: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    todoProvider.deleteById(helperValue.id);
                    todoProvider.todoItem.remove(helperValue);
                    // Na função DeleteDialog, após deletar o item:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tarefa excluída com sucesso!'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Sim'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Atualizado de "primary"
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Não',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DeleteTableDialog extends StatelessWidget {
  const DeleteTableDialog({Key? key, required this.todoP}) : super(key: key);

  final TodoProvider todoP;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text('Deletar tudo'),
      content: const Text('Tem certeza que deseja excluir tudo?'),
      actions: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  onPressed: () async {
                    await todoP.deleteTable();
                    Navigator.pop(context);
                  },
                  child: const Text('Sim'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 186, 186), // Atualizado de "primary"
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Não',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}