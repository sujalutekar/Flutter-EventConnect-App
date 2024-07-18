import 'package:event_connect/authentication/onboarding/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    color: currentPage == 0
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    color: currentPage == 1
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 10,
                    width: 10,
                    color: currentPage == 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentPage = page;
              });
            },
            children: const [
              Page1(),
              Page2(),
              Page3(),
            ],
          ),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterLogo(
            size: 100,
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to Event Connect!',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            'Connect with events in your area',
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/Animation - 1720414624238.json',
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Create & Manage Events',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Effortlessly organize events with detailed descriptions and images.',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/Animation - 1720415048213.json',
                    height: 150,
                  ),
                  const Text(
                    'Timely Notifications',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Stay updated with automatic reminders and notifications.',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/Animation - 1720415133548.json',
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Track Event History',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Access past events and keep track of your activities.',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1720415265446.json',
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'User-Friendly Interface',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Experience a seamless and intuitive user interface.',
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 50),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1720415458367.json',
                        height: 150,
                      ),
                      // const SizedBox(height: 10),
                      const Text(
                        'Build Your Community',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Connect and engage with people in your organization.',
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 50),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/Animation - 1720415379191.json',
                        height: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Boost Your Productivity',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Manage your tasks and events efficiently with timely reminders.',
                        style: TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                print('Get Started Now!');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 60,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'Get Started Now!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
