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
