import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? svgAsset;
  final VoidCallback onTap;
  final bool fullWidth;

  const SocialButton({
    super.key,
    required this.label,
    this.icon,
    this.svgAsset,
    required this.onTap,
    this.fullWidth = false,
  }) : assert(icon != null || svgAsset != null,
            'Either icon or svgAsset must be provided');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset!,
                height: 24,
                width: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            else if (icon != null)
              Icon(icon),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
