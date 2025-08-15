import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'dot_indicator.dart';

class AutoScrollCarousel extends StatefulWidget {
  const AutoScrollCarousel({super.key});

  @override
  AutoScrollCarouselState createState() => AutoScrollCarouselState();
}

class AutoScrollCarouselState extends State<AutoScrollCarousel> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 350,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 1.0,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }, // Set the interval for auto-scroll
            ),
            items: const [
              CoursalItem(
                lottieName: 'tiger.json',
                titel: 'Welcome to Peekaboo Learn!',
                subtitle: 'Where Learning is always Fun!',
              ),
              CoursalItem(
                lottieName: 'child.json',
                titel: 'Play and Explore!',
                subtitle: 'Explore, play, and learn with engaging games!',
              ),
              CoursalItem(
                lottieName: 'parrot.json',
                titel: 'Talk and Learn',
                subtitle: 'Engage in Conversations, Learn and Grow',
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedDotIndicator(
            itemCount: 3,
            currentIndex: _currentIndex,
            dotSize: 8,
            spacing: 5,
            dotColor: Colors.grey,
            activeDotColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class CoursalItem extends StatelessWidget {
  const CoursalItem({
    super.key,
    required this.lottieName,
    required this.titel,
    required this.subtitle,
  });
  final String lottieName;
  final String titel;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child:
              Lottie.asset("assets/lottie/$lottieName", fit: BoxFit.fitHeight),
        ),
        Text(
          titel,
          style: TextStyle(
            fontSize: 25,
            fontFamily: GoogleFonts.schoolbell().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
