import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../widgets/common/network_image_with_loader.dart';

// ✅ CHUYỂN THÀNH STATEFULWIDGET
class MenuCategoryCarousel extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const MenuCategoryCarousel({
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  State<MenuCategoryCarousel> createState() => _MenuCategoryCarouselState();
}

class _MenuCategoryCarouselState extends State<MenuCategoryCarousel> {
  // ✅ "GHI NHỚ" DỮ LIỆU STREAM
  late final Stream<DatabaseEvent> _bannerStream;

  final List<String> categoryLabels = const [
    'Món Canh',
    'Món Mặn',
    'Món Xào',
  ];

  @override
  void initState() {
    super.initState();
    // ✅ CHỈ LẤY DỮ LIỆU MỘT LẦN DUY NHẤT KHI WIDGET ĐƯỢC TẠO
    _bannerStream = FirebaseDatabase.instance.ref('banners').onValue;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 170.h,
      child: StreamBuilder<DatabaseEvent>(
        stream: _bannerStream, // ✅ SỬ DỤNG STREAM ĐÃ "GHI NHỚ"
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text('Không thể tải banners'));
          }

          final bannerData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final bannerUrls = bannerData.values.map((e) => e as String).toList();

          return CarouselSlider.builder(
            itemCount: bannerUrls.length,
            itemBuilder: (context, index, realIndex) {
              final imageUrl = bannerUrls[index];
              final label = (index < categoryLabels.length) ? categoryLabels[index] : '';
              final isSelected = widget.selectedCategory == label;

              return Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () => widget.onCategorySelected(label),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: NetworkImageWithLoader(
                            imageUrl: imageUrl,
                            width: double.infinity,
                            height: 150.h,
                          ),
                        ),
                        Container(
                          height: 150.h,
                          decoration: BoxDecoration(
                            color: colorScheme.scrim.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.limeAccent : Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Borel',
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.6),
                                offset: const Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () => widget.onCategorySelected(''),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.scrim.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6.w),
                          child: Icon(
                            Icons.close,
                            color: colorScheme.onPrimary,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            options: CarouselOptions(
              height: 160.h,
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.8,
            ),
          );
        },
      ),
    );
  }
}
