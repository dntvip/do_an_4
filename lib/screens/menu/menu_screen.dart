import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import 'widgets/menu_app_bar.dart';
import 'widgets/menu_category_carousel.dart';
import 'widgets/menu_grid_item.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ SỬ DỤNG context.watch ĐỂ LẮNG NGHE TOÀN BỘ PROVIDER
    final menuProvider = context.watch<MenuProvider>();
    _searchController.text = menuProvider.searchQuery;

    Widget buildBody() {
      // ✅ HIỂN THỊ VÒNG XOAY KHI DỮ LIỆU ĐANG TẢI LẦN ĐẦU
      if (menuProvider.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      
      // Lấy danh sách món ăn đã được lọc từ provider
      final filteredItems = menuProvider.filteredFoodItems;

      if (filteredItems.isEmpty) {
        return const Center(child: Text('Không tìm thấy món ăn nào'));
      }

      return GridView.builder(
        padding: EdgeInsets.only(top: 10.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final food = filteredItems[index];
          return MenuGridItem(
            food: food,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/food-detail',
                arguments: food,
              );
            },
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuCustomAppBar(
              searchController: _searchController,
              onSearchChanged: (value) => context.read<MenuProvider>().setSearchQuery(value),
            ),
            SizedBox(height: 12.h),
            MenuCategoryCarousel(
              selectedCategory: menuProvider.selectedCategory,
              onCategorySelected: (value) => context.read<MenuProvider>().setSelectedCategory(value),
            ),
            SizedBox(height: 12.h),
            Expanded(child: buildBody()),
          ],
        ),
      ),
    );
  }
}
