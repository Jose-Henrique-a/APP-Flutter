import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutterversaoweb/model/todo_model.dart';

class DBHelper {
  static const String todoBox = 'todo';

  static Future<void> init() async {
    await Hive.initFlutter('flutterversaoweb'); // Caminho explícito para armazenamento
    print("Hive initialized for Flutter with path: flutterversaoweb");
    Hive.registerAdapter(TodoModelAdapter());
    final box = await Hive.openBox<TodoModel>(todoBox);
    print("Hive box opened: ${box.isOpen}, items: ${box.length}");
  }

  static Future<List<TodoModel>> selectAll() async {
    final box = await Hive.openBox<TodoModel>(todoBox);
    final items = box.values.toList();
    print("Selected all todos: ${items.length} items");
    return items;
  }

  static Future<void> insert(TodoModel todo) async {
    final box = await Hive.openBox<TodoModel>(todoBox);
    await box.put(todo.id, todo);
    await box.flush(); // Forçar gravação no IndexedDB
    print("Inserted todo: ${todo.id}, title: ${todo.title}, box size: ${box.length}");
    await box.close(); // Fechar o box para garantir persistência
  }

  static Future<void> update(TodoModel todo) async {
    final box = await Hive.openBox<TodoModel>(todoBox);
    await box.put(todo.id, todo);
    await box.flush(); // Forçar gravação no IndexedDB
    print("Updated todo: ${todo.id}, title: ${todo.title}, box size: ${box.length}");
    await box.close(); // Fechar o box para garantir persistência
  }

  static Future<void> deleteById(String id) async {
    final box = await Hive.openBox<TodoModel>(todoBox);
    await box.delete(id);
    await box.flush(); // Forçar gravação no IndexedDB
    print("Deleted todo: $id, box size: ${box.length}");
    await box.close(); // Fechar o box para garantir persistência
  }

  static Future<void> deleteTable() async {
    final box = await Hive.openBox<TodoModel>(todoBox);
    await box.clear();
    await box.flush(); // Forçar gravação no IndexedDB
    print("Cleared box, size: ${box.length}");
    await box.close(); // Fechar o box para garantir persistência
  }
}

class TodoModelAdapter extends TypeAdapter<TodoModel> {
  @override
  final int typeId = 0;

  @override
  TodoModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final date = reader.readString();
    print("Reading todo: $id");
    return TodoModel(
      id: id,
      title: title,
      description: description,
      date: date,
    );
  }

  @override
  void write(BinaryWriter writer, TodoModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.date);
    print("Writing todo: ${obj.id}");
  }
}