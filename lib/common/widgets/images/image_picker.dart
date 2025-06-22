import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';

class DottedBorderImagePicker extends StatefulWidget {
  const DottedBorderImagePicker({
    super.key,
    this.imageFile,
    required this.onTap,
    this.height = 100,
    this.width = 100,
  });

  final File? imageFile;
  final VoidCallback onTap;
  final double height;
  final double width;

  @override
  DottedBorderImagePickerState createState() => DottedBorderImagePickerState();
}

class DottedBorderImagePickerState extends State<DottedBorderImagePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  File? _currentImageFile;

  @override
  void initState() {
    super.initState();
    _currentImageFile = widget.imageFile;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Animation duration
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Start with full opacity
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(DottedBorderImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageFile != widget.imageFile) {
      // Trigger animation when imageFile changes
      _animationController.reset();
      setState(() {
        _currentImageFile = widget.imageFile;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        color: MyColors.darkPrimaryColor,
        dashPattern: const [6, 3],
        strokeWidth: 2,
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(MySizes.cardRadiusMd)),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: _currentImageFile != null
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Image.file(
                      _currentImageFile!,
                      fit: BoxFit.cover,
                      width: widget.width,
                      height: widget.height,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 40,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(height: MySizes.spaceBtwItems),
                      Text(
                        "Thêm",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .apply(color: MyColors.primaryColor),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
