import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  // State variable to track the currently selected item in the navigation bar.
  // Initialized to -1 to ensure no item has a pill or text initially.
  int _internalCurrentIndex = -1;

  @override
  void initState() {
    super.initState();
    // No need to set _internalCurrentIndex from widget.currentIndex here
    // as per the new requirement of no pill initially.
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This logic syncs _internalCurrentIndex with the outside currentIndex (from the parent screen).
    // However, with the "tap again to go to menu and default state" requirement,
    // external updates can be complex.
    // We'll assume _internalCurrentIndex is primarily managed within the nav bar.
    // If you need the parent screen to actively change the selected item
    // and show a pill, you might need further adjustments here.
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: colorScheme.primary, // Dark green color from your theme
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.dataset_outlined, Icons.dataset, 'Thực Đơn', 0),
            _buildNavItem(context, Icons.shopping_cart_outlined, Icons.shopping_cart, 'Giỏ hàng', 1),
            _buildNavItem(context, Icons.person_outline, Icons.person, 'Tài khoản', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      IconData icon,
      IconData activeIcon,
      String label,
      int itemIndex, // Renamed to avoid loop index conflict
      ) {
    // Check if the current item is selected in the nav bar
    final bool isActuallySelected = itemIndex == _internalCurrentIndex;
    final colorScheme = Theme.of(context).colorScheme;
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isActuallySelected) {
            // Case 1: Tapping the currently selected item again
            // Deselect the item on the nav bar (no pill, no text)
            _internalCurrentIndex = -1;
            // Navigate back to Menu (index 0)
            widget.onTap(0);
          } else {
            // Case 2: Tapping a different item or no item is currently selected
            // Select the new item and show pill + text
            _internalCurrentIndex = itemIndex;
            // Navigate to the corresponding page
            widget.onTap(itemIndex);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          padding: EdgeInsets.symmetric(
            horizontal: isActuallySelected ? 14 : 0, // Add horizontal padding when selected
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isActuallySelected
                ? colorScheme.secondary // Pill background color is secondary (light green)
                : Colors.transparent, // No color when not selected
            borderRadius: BorderRadius.circular(24),
            boxShadow: isActuallySelected
                ? [
              // FIX: Changed 'BoxBoxShadow' to 'BoxShadow'
              BoxShadow(
                color: colorScheme.secondary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              // Always show CircleAvatar for the icon, but with a transparent background
              // as per the requirement "no circle around" when not selected.
              CircleAvatar(
                radius: 18,
                backgroundColor: isActuallySelected
                    ? Colors.transparent // Transparent when selected
                    : Colors.transparent, // Also transparent when NOT selected
                child: Icon(
                  isActuallySelected ? activeIcon : icon, // Change icon from outline to filled when selected
                  color: isActuallySelected
                      ? bottomNavTheme.selectedItemColor // Icon when selected: Lime Green
                      : bottomNavTheme.unselectedItemColor, // Icon when not selected: White
                  size: 24,
                ),
              ),
              // DISPLAY TEXT ONLY WHEN SELECTED
              if (isActuallySelected) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: bottomNavTheme.selectedItemColor, // Text when selected: Lime Green
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}