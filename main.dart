import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(home: FreshTrackApp()));

class FreshTrackApp extends StatefulWidget {
  @override
  _FreshTrackAppState createState() => _FreshTrackAppState();
}

class _FreshTrackAppState extends State<FreshTrackApp> {
  String _result = "Scan your food to begin";
  bool _loading = false;

  Future<void> _scanFood() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() => _loading = true);
      
      // Send to Backend (Replace with your Cloud URL later)
      var request = http.MultipartRequest('POST', Uri.parse('http://localhost:8000/analyze'));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _result = "Status: ${data['status']}\nExpiry: ${data['expiry_date']}";
          _loading = false;
        });
      }
    }
  }

  if (response.statusCode == 200) {
  var data = json.decode(response.body);
  String foundDateStr = data['expiry_date'];

  if (foundDateStr != "No date detected") {
    // Convert string "MM/DD/YYYY" to DateTime object
    DateTime expiry = DateTime.parse(foundDateStr.replaceAll('/', '-')); 
    
    // Save to database AND schedule alert
    await scheduleExpiryAlert(DateTime.now().millisecondsSinceEpoch % 1000, data['food_item'], expiry);
  }

  setState(() {
    _result = "Status: ${data['status']}\nExpiry: $foundDateStr";
    _loading = false;
  });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🍎 FreshTrack AI")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loading ? CircularProgressIndicator() : Text(_result, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _scanFood, 
              icon: Icon(Icons.camera_alt), 
              label: Text("Scan Food Item")
            ),
          ],
        ),
      ),
    );
  }
}
