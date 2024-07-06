import 'package:flutter/material.dart';
import 'package:employee_manager/guest/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Map<String, String>> slides = [
    {
      'image': 'assets/img_qlnv1.png',
      'title': 'Chào mừng đến với Quản lý nhân viên ',
      'subtitle': 'Ứng dụng quản lý thông tin nhân viên một cách dễ dàng và hiệu quả.',
    },
    {
      'image': 'assets/img_qlnv2.png',
      'title': 'Quản lý Nhân Viên',
      'subtitle': 'Cung cấp công cụ để quản lý thông tin và hiệu suất của nhân viên.',
    },
    {
      'image': 'assets/img_bcpt.png',
      'title': 'Báo Cáo và Thống Kê',
      'subtitle': 'Theo dõi và phân tích hiệu suất làm việc qua các báo cáo chi tiết.',
    },
  ];

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: slides.length,
                itemBuilder: (context, index) => SlideItem(
                  image: slides[index]['image']!,
                  title: slides[index]['title']!,
                  subtitle: slides[index]['subtitle']!,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                          (index) => buildDot(index, context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _currentPage == slides.length - 1
                        ? ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text("BẮT ĐẦU"),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _pageController.jumpToPage(slides.length - 1);
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Text("BỎ QUA"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Text("TIẾP THEO"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  SlideItem({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 220,
          width: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image.startsWith('http')
                  ? NetworkImage(image)
                  : AssetImage(image),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a Future.delayed to simulate a condition (e.g., after a login check)
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Show a loading indicator while navigating
    );
  }
}
