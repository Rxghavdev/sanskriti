import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CarouselController carouselController = CarouselController();
  List<dynamic>? imageList;
  List<dynamic>? factsList;
  Random random = Random();
  int imageIndex = 0;
  int imageNumber = 0;
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey _widgetKey = GlobalKey();
  var selectedLang = "English";
  var factLang = "fact";
  int toggleIndex = 0;
  final baseUrl = "http://app-d2hf.onrender.com"; // Replace with your API base URL

  @override
  void initState() {
    super.initState();
    getImages();
    getFacts();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: imageList != null && factsList != null
                ? RepaintBoundary(
              key: _widgetKey,
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(seconds: 1),
                    child: BlurHash(
                      key: ValueKey(imageList![imageIndex]['blur_hash']),
                      hash: imageList![imageIndex]['blur_hash'],
                      image: imageList![imageIndex]['image_url'],
                      curve: Curves.easeInOut,
                      imageFit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: width,
                    height: height,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  Container(
                    width: width,
                    height: height,
                    child: SafeArea(
                      child: CarouselSlider.builder(
                        carouselController: carouselController,
                        itemCount: factsList!.length, // Use ! to assert non-null
                        itemBuilder: (context, index1, index2) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  factsList![index1][factLang],
                                  style: kQuoteTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '- ${factsList![index1]['source']} -',
                                style: kAuthorTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                        options: CarouselOptions(
                          scrollDirection: Axis.vertical,
                          pageSnapping: true,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, value) {
                            HapticFeedback.lightImpact();
                            imageNumber = index;
                            if (index < imageList!.length) {
                              imageIndex = index;
                            } else {
                              imageIndex = random.nextInt(imageList!.length);
                            }
                            if (imageNumber % 15 == 0) {
                              // Perform some action on a specific index.
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 20,
                    child: Container(
                      width: 60, // Adjust the width to your desired size
                      height: 60, // Adjust the height to your desired size
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/app_logo.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 30,
                    child: Row(
                      children: [
                        ToggleSwitch(
                          minWidth: 70.0,
                          minHeight: 40.0,
                          cornerRadius: 20.0,
                          activeBgColors: [
                            [ui.Color.fromARGB(255, 39, 40, 39)],
                            [ui.Color.fromARGB(255, 39, 40, 39)]
                          ],
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: toggleIndex,
                          totalSwitches: 2,
                          labels: ['English', 'Hindi'],
                          radiusStyle: true,
                          onToggle: (index) {
                            setState(() {
                              if (index == 1) {
                                toggleIndex = 1;
                                selectedLang = 'हिंदी';
                                factLang = "hindi_description";
                              } else {
                                selectedLang = 'English';
                                toggleIndex = 0;
                                factLang = "fact";
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 16,
                    child: Column(
                      children: [
                        LikeButton(
                          size: 30,
                          likeCount: factsList![imageNumber]['likes'],
                          countPostion: CountPostion.bottom,
                          likeBuilder: (bool isLiked) {
                            // Implement your like button here
                          },
                          //onTap: onLikeButtonTapped,
                        ),
                        IconButton(
                          color: Colors.white,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            //_captureScreenshot();
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : Container(
              width: width,
              height: height,
              color: Colors.black.withOpacity(0.6),
              child: Container(
                width: 100,
                height: 100,
                child: SpinKitFadingCircle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Container(
              color: Colors.black,
              child: Container(
                color: Colors.black,
                margin: EdgeInsets.only(bottom: 25),
                height: 50,
                child: GNav(
                  rippleColor: Colors.purpleAccent,
                  hoverColor: Colors.purpleAccent,
                  haptic: true,
                  tabBorderRadius: 15,
                  tabActiveBorder: Border.all(color: Colors.black, width: 1),
                  tabBorder: Border.all(color: Colors.black12, width: 1),
                  tabShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.5),
                      blurRadius: 8,
                    )
                  ],
                  curve: Curves.easeOutExpo,
                  duration: Duration(milliseconds: 900),
                  gap: 8,
                  color: Colors.white,
                  activeColor: Colors.purple,
                  iconSize: 24,
                  tabBackgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  tabs: [
                    GButton(
                      icon: Icons.menu,
                      text: 'Menu',
                      onPressed: () {
                        //_showSlideDrawer(context);
                      },
                    ),
                    GButton(
                      icon: Icons.refresh,
                      text: 'Refresh',
                      onPressed: () {
                        carouselController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                    ),
                    GButton(
                      icon: Icons.info,
                      text: 'Information',
                      onPressed: () {
                        // Navigate to the information page
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getImages() async {
    try {
      var url = '$baseUrl/users/getImages';
      var uri = Uri.parse(url);
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        imageList = data;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  void getFacts() async {

    try {
      var url = '$baseUrl/users/getFacts';
      var uri = Uri.parse(url);
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        factsList = data;
        setState(() {});
      }
    } catch (e) {
      print('Error fetching facts: $e');
    }

  void _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
      _widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final screenshot = byteData.buffer.asUint8List();
        final tempDir = await getTemporaryDirectory();
        final file =
        await File('${tempDir.path}/screenshot.png').writeAsBytes(screenshot);
        await Share.shareFiles([file.path], mimeTypes: ['image/png']);
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    final url = Uri.parse('$baseUrl/users/likeFact/${factsList![imageNumber]['_id']}');
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        isLiked = true;
        factsList![imageNumber]['likes'] += 1;
      } else {
        print('Failed to update data. Error: ${response.body}');
        isLiked = false;
      }
    } catch (error) {
      print('An error occurred: $error');
      isLiked = false;
    }
    return isLiked;
  }

  void _showSlideDrawer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              // Add your menu items here
            ],
          ),
        );
      },
    );
  }
}}
