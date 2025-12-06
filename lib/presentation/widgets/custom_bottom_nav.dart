import 'package:flutter/material.dart';
import '../themes/constants.dart';
import '../../l10n/app_localizations.dart';

class CustomBottomNav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final VoidCallback? onAddPressed;
  final bool isAdmin;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.onAddPressed,
    this.isAdmin = false,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  // Track hover states for each nav item (max 5 for admin)
  final List<bool> _isHovered = [false, false, false, false, false];
  bool _isAddButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 65,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.isAdmin
                ? [
                    _buildNavItem(Icons.home_outlined, l10n.home, 0),
                    _buildNavItem(Icons.list_alt_outlined, l10n.problems, 1),
                    const SizedBox(width: 60),
                    _buildNavItem(Icons.admin_panel_settings_outlined, 'Admin', 3),
                    _buildNavItem(Icons.person_outline, l10n.profile, 4),
                  ]
                : [
                    _buildNavItem(Icons.home_outlined, l10n.home, 0),
                    _buildNavItem(Icons.list_alt_outlined, l10n.problems, 1),
                    const SizedBox(width: 60),
                    _buildNavItem(Icons.business_outlined, l10n.organizations, 2),
                    _buildNavItem(Icons.person_outline, l10n.profile, 3),
                  ],
          ),
        ),

        // Floating "+" button with hover effect
        Positioned(
          top: -28,
          child: GestureDetector(
            onTap: widget.onAddPressed,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isAddButtonHovered = true),
              onExit: (_) => setState(() => _isAddButtonHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isAddButtonHovered ? 66 : 62,
                height: _isAddButtonHovered ? 66 : 62,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: _isAddButtonHovered ? 12 : 8,
                      offset: Offset(0, _isAddButtonHovered ? 4 : 3),
                    ),
                  ],
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: _isAddButtonHovered ? 1.1 : 1.0,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = widget.selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        // Add tap feedback
        setState(() {
          _isHovered[index] = true;
        });
        
        // Reset after animation
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            _isHovered[index] = false;
          });
        });
        
        widget.onItemTapped(index);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered[index] = true),
        onExit: (_) => setState(() => _isHovered[index] = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _isHovered[index] 
                ? AppColors.primaryGreen.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..scale(_isHovered[index] ? 1.2 : 1.0),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primaryGreen : Colors.grey[700],
                  size: 26,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovered[index] ? 0.8 : 1.0,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primaryGreen : Colors.grey[700],
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


