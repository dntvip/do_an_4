import 'package:flutter/material.dart';

class AppScreenLayout extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar; // AppBar là tùy chọn
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset; // Thêm thuộc tính này

  const AppScreenLayout({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true, // Mặc định là true
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea( // Đảm bảo nội dung không bị che bởi thanh trạng thái/tai thỏ
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset, // Áp dụng thuộc tính
    );
  }
}