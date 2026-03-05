import 'package:crm_pro/common/app_colors.dart';
import 'package:crm_pro/common/app_constants.dart';
import 'package:crm_pro/widgets/app_search_field.dart';
import 'package:crm_pro/widgets/home_carousel_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> bannerData = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=200&fit=crop',
      'title': 'Premium Products',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1491553895911-0055eca6402d?w=500&h=200&fit=crop',
      'title': 'Latest Collection',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500&h=200&fit=crop',
      'title': 'Special Offers',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //  Custom AppBar with Search and Icons
            CustomAppBarWidget(searchController: _searchController),

            // Carousel Widget with Banners and Indicators
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: HomeCarouselWidget(banners: bannerData),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingXLarge,
      ),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppSearchField(
                controller: _searchController,
                hintText: 'Search customers...',
                width: 250,
                onChanged: (value) {},
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.inputFill,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.message_outlined,
                  color: AppColors.inputFill,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
