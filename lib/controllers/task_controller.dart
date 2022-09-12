import 'package:get/get.dart';
import 'package:udemy_todo/models/task.dart';

import '../db/db_helper.dart';

class TaskController extends GetxController {
  final tasklist = <Task>[].obs;

  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    tasklist.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void deleteAll() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
