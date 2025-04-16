import 'package:flutter/material.dart';
import 'package:flutterversaoweb/db_helper/db_helper.dart';
import 'package:flutterversaoweb/model/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> todoItem = [];

  Future<void> selectData() async {
    try {
      final dataList = await DBHelper.selectAll();
      todoItem = dataList;
      notifyListeners();
    } catch (error) {
      print("Error selecting data: $error");
    }
  }

  Future<bool> insertData(
    String title,
    String description,
    String date,
  ) async {
    final newTodo = TodoModel(
      id: const Uuid().v1(),
      title: title,
      description: description,
      date: date,
    );

    try {
      await DBHelper.insert(newTodo);
      todoItem.add(newTodo);
      notifyListeners();
      return true;
    } catch (error) {
      print("Error inserting data: $error");
      return false;
    }
  }

  Future<void> updateTitle(String id, String title) async {
    try {
      final index = todoItem.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedTodo = TodoModel(
          id: todoItem[index].id,
          title: title,
          description: todoItem[index].description,
          date: todoItem[index].date,
        );
        await DBHelper.update(updatedTodo);
        todoItem[index] = updatedTodo;
        notifyListeners();
      }
    } catch (error) {
      print("Error updating title: $error");
    }
  }

  Future<void> updateDescription(String id, String description) async {
    try {
      final index = todoItem.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedTodo = TodoModel(
          id: todoItem[index].id,
          title: todoItem[index].title,
          description: description,
          date: todoItem[index].date,
        );
        await DBHelper.update(updatedTodo);
        todoItem[index] = updatedTodo;
        notifyListeners();
      }
    } catch (error) {
      print("Error updating description: $error");
    }
  }

  Future<void> updateDate(String id, String date) async {
    try {
      final index = todoItem.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedTodo = TodoModel(
          id: todoItem[index].id,
          title: todoItem[index].title,
          description: todoItem[index].description,
          date: date,
        );
        await DBHelper.update(updatedTodo);
        todoItem[index] = updatedTodo;
        notifyListeners();
      }
    } catch (error) {
      print("Error updating date: $error");
    }
  }

  Future<void> deleteById(String id) async {
    try {
      await DBHelper.deleteById(id);
      todoItem.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (error) {
      print("Error deleting item by ID: $error");
    }
  }

  Future<void> deleteTable() async {
    try {
      await DBHelper.deleteTable();
      todoItem.clear();
      notifyListeners();
    } catch (error) {
      print("Error deleting table: $error");
    }
  }
}