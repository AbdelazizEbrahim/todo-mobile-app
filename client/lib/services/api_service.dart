import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  static const String baseUrl = 'https://todo-mobile-app-abcs.onrender.com';

  // Register a new user
  Future<String> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        return await login(email, password);
      } else {
        print('Register failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  // Login an existing user
  Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['userId'];
      } else {
        print('Login failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  // Add a ToDo item
  Future<void> addToDo(String userId, String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/todos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode != 201) {
        print('Add ToDo failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to add ToDo: ${response.body}');
      }
    } catch (e) {
      print('Error adding ToDo: $e');
      rethrow;
    }
  }

  // Update a ToDo item
  Future<void> updateToDo(String todoId, String title, String description) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/todos/$todoId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode != 200) {
        print('Update ToDo failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to update ToDo: ${response.body}');
      }
    } catch (e) {
      print('Error updating ToDo: $e');
      rethrow;
    }
  }

  // Delete a ToDo item
  Future<void> deleteToDo(String todoId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/todos/$todoId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        print('Delete ToDo failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to delete ToDo: ${response.body}');
      }
    } catch (e) {
      print('Error deleting ToDo: $e');
      rethrow;
    }
  }

  // Fetch ToDo items for a user
  Future<List<ToDo>> getToDos(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ToDo.fromJson(json)).toList();
      } else {
        print('Fetch ToDos failed: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to fetch ToDos: ${response.body}');
      }
    } catch (e) {
      print('Error fetching ToDos: $e');
      rethrow;
    }
  }
}