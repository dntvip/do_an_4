import 'package:flutter/material.dart';

// Import các màn hình con
import '../menu/menu_screen.dart';
import '../cart/cart_screen.dart';
import '../profile/profile_screen.dart';

// Import common widgets
import '../../widgets/common/app_screen_layout.dart'; // Sử dụng AppScreenLayout
import '../../widgets/common/custom_bottom_nav_bar.dart'; // CustomBottomNavBar vẫn được sử dụng

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // Khai báo _screens là late final để khởi tạo trong initState
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Khởi tạo danh sách các màn hình tương ứng với các tab
    _screens = const [
      MenuScreen(),    // Màn hình Thực Đơn
      CartScreen(),    // Màn hình Giỏ hàng
      ProfileScreen(), // Màn hình Tài khoản
    ];
  }

  // Hàm được gọi khi người dùng chạm vào một tab trên BottomNavBar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Cập nhật chỉ số của tab đang được chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScreenLayout( // Bọc HomeScreen trong AppScreenLayout
      // HomeScreen không có AppBar riêng, các màn hình con sẽ tự định nghĩa AppBar
      // hoặc không có nếu là full-screen content.
      // body của AppScreenLayout sẽ là IndexedStack chứa các màn hình con
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // bottomNavigationBar của AppScreenLayout sẽ là CustomBottomNavBar
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      // backgroundColor có thể được đặt ở đây nếu bạn muốn nền chung cho toàn bộ Scaffold
      // Hoặc để mặc định theo theme
      // backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}