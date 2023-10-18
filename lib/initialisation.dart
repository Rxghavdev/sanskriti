import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

List<dynamic> factsList = [];
var config_service_url = "https://app-d2hf.onrender.com"; // Add "https://" to the URL

Future<void> fetchFacts() async {
  try {
    String service_url = await getServiceURL();
    print(service_url);
    final response = await http.get(Uri.parse(service_url + '/users/getFacts'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List) {
        factsList = jsonData;
      } else {
        // Handle the case when the response is not a list (JSON structure doesn't match).
        print('Invalid JSON structure: $jsonData');
      }
    } else {
      // Handle HTTP error (e.g., status code is not 200).
      print('HTTP Error - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    // Handle other exceptions, e.g., network issues.
    print('Error in fetchFacts: $e');
  }
}

Future<void> fetchServiceURL() async {
  try {
    final response = await http.get(Uri.parse(config_service_url + '/data'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData is List && jsonData.isNotEmpty) {
        String serviceURL = jsonData[0]["service_url"];
        setServiceURL(serviceURL);
      } else {
        // Handle the case when the response is not as expected.
        print('Invalid service URL response: $jsonData');
      }
    } else {
      // Handle HTTP error for service URL retrieval.
      print('HTTP Error - Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    // Handle other exceptions, e.g., network issues.
    print('Error in fetchServiceURL: $e');
  }
}

Future<void> setServiceURL(serviceURL) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("service_url", serviceURL);
}

Future<String> getServiceURL() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? serviceURL = prefs.getString("service_url");
  if (serviceURL != null) {
    return serviceURL;
  } else {
    await fetchServiceURL(); // Wait for service URL to be fetched
    serviceURL = prefs.getString("service_url");
    if (serviceURL != null) {
      return serviceURL;
    } else {
      return "no service url available";
    }
  }
}
