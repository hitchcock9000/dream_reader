import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final apiKey = dotenv.env['OPENAI_API_KEY'];
  if (apiKey == null) {
    print('Key missing');
    return;
  }

  print('Testing DALL-E 3 with prompt: A cosmic nebula dream');
  try {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'dall-e-3',
        'prompt': 'A cosmic nebula dream',
        'n': 1,
        'size': '1024x1024',
        'quality': 'standard',
      }),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
