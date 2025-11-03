import 'package:http/http.dart' as http;
import 'dart:convert' as convert; //


void main() async { 
  var url = Uri.https('jsonplaceholder.typicode.com', '/posts/1');
  final response = await http.get(url,   
       headers: {
      'User-Agent': 'Dart/3.0 (https://dart.dev)',
      'Accept': 'application/json',
    });

  if (response.statusCode == 200) {
    var data = convert.jsonDecode(response.body);
    print('Title: ${data['title']}');
    print('Body: ${data['body']}');
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
} 
