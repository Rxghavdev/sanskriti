import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'initialisation.dart';

class AboutUsPage extends StatefulWidget {

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
   String aboutData='null';

  @override
  void initState()  {
    super.initState();
    fetchAboutData();
  }

  void fetchAboutData() async {
    final response = await http.get(Uri.parse(config_service_url+'/aboutus'));
    if (response.statusCode == 200) {
    print(response.body);
      var jsonData= json.decode(response.body);
      aboutData=jsonData['about_us'];
      setState(() {});
    } else {
      throw Exception('Failed to load data from API');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        //purple color
        backgroundColor: Color(0xFF6A1B9A),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[900],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Our App',
                style: TextStyle(
                  fontFamily: 'Belanosima',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                aboutData,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 58), // Extra space to prevent overlapping with the bottom app bar
            ],
          ),
        ),
      ),
    );
  }
}
