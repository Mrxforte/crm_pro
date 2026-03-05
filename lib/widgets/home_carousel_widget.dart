import 'package:carousel_slider/carousel_slider.dart';
import 'package:crm_pro/widgets/carousel_banner_item.dart';
import 'package:flutter/material.dart';

class HomeCarouselWidget extends StatefulWidget {
  final List<Map<String, String>> banners;

  const HomeCarouselWidget({super.key, required this.banners});

  @override
  State<HomeCarouselWidget> createState() => _HomeCarouselWidgetState();
}

class _HomeCarouselWidgetState extends State<HomeCarouselWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.banners
              .map(
                (banner) => CarouselBannerItem(
                  imageUrl: banner['imageUrl'] ?? '',
                  title: banner['title'] ?? '',
                  onTap: () {
                    // TODO: Add navigation on banner tap
                  },
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            scrollPhysics: const BouncingScrollPhysics(),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentIndex == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
