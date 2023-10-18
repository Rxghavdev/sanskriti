import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'main.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final Function onboardingCompleteCallback;
  const OnboardingScreen({Key? key, required this.onboardingCompleteCallback}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<Map<String, String>> _onboardData = [
    {
      'image': 'assets/fun-3d-illustration-cartoon-businessman-with-vr-helmet-removebg-preview.png',
      'title': 'Welcome to\nHindu Sanskriti!',
      'description': '',
    },
    {
      'image': 'assets/meditate.png.png',
      'title': 'Explore and Embrace Spiritual Wisdom',
      'description': 'Explore and Embrace Spiritual Wisdom',
    },
    {
      'image': 'assets/features.png',
      'title': 'Unlock the Full Potential of Hindu Sanskriti',
      'description': '• Daily Facts\n• Liking Facts\n• Multilanguage Support',
    },
  ];

  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.grey[900], // Set the background color
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardData.length,
                  itemBuilder: (context, index) => OnboardContent(
                    image: _onboardData[index]['image']!,
                    title: _onboardData[index]['title']!,
                    description: _onboardData[index]['description']!,
                  ),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: Column(
                  children: [
                    SizedBox(height: 19),
                    Container(
                      height: 40,
                      child: DotsIndicator(
                        dotsCount: _onboardData.length,
                        position: _currentPageIndex.toDouble(),
                        decorator: DotsDecorator(
                          size: const Size.square(6),
                          activeSize: const Size.square(10),
                          color: Colors.grey,
                          activeColor: Colors.purple,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      height: 60,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPageIndex < _onboardData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            widget.onboardingCompleteCallback();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          }
                        },
                        child: const Icon(Icons.arrow_forward),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          primary: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    this.imageHeight = 300.0,
    this.imageWidth = 500.0,
  }) : super(key: key);

  final String image, title, description;
  final double imageHeight;
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: imageHeight,
            width: imageWidth,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          if (title.isNotEmpty)
            Text.rich(
              TextSpan(
                text: title,
                style: const TextStyle(
                  fontFamily: 'Belanosima',
                  fontSize: 24,
                  color: Colors.white,
                ),
                children: title.contains('\n') ? <InlineSpan>[] : null,
              ),
              textAlign: TextAlign.center,
            ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Belanosima',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
