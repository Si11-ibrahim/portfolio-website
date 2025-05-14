import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../shared/widgets/social_button.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use a more precise check for different screen sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 450; // Mobile phones
    final isSmallScreen =
        screenWidth < 600 && !isVerySmallScreen; // Small tablets
    final isMediumScreen =
        screenWidth >= 600 && screenWidth < 900; // Larger tablets

    return SelectionArea(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SelectableText(
              'Get In Touch',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (isVerySmallScreen)
              // Very small screens - full width stacked buttons
              Column(
                children: [
                  SocialButton(
                    label: 'GitHub',
                    svgAsset: 'assets/icons/github.svg',
                    onTap: () => _launchUrl('https://github.com/Si11-ibrahim'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'LinkedIn',
                    svgAsset: 'assets/icons/linkedin.svg',
                    onTap: () =>
                        _launchUrl('https://linkedin.com/in/Si11-ibrahim'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Instagram',
                    svgAsset: 'assets/icons/instagram.svg',
                    onTap: () => _launchUrl('https://instagram.com/si11_ibu'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'X',
                    svgAsset: 'assets/icons/x.svg',
                    onTap: () => _launchUrl('https://x.com/Si11_ibrahim'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Medium',
                    svgAsset: 'assets/icons/medium.svg',
                    onTap: () =>
                        _launchUrl('https://medium.com/@ahamedibrahim0004'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    onTap: () =>
                        _launchUrl('mailto:s.ahmedibrahimsi11@gmail.com'),
                    fullWidth: true,
                  ),
                ],
              )
            else if (isSmallScreen || isMediumScreen)
              // Small and medium screens - auto-wrap layout with 2-3 buttons per row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16, // Horizontal space between buttons
                runSpacing: 16, // Vertical space between rows
                children: [
                  SocialButton(
                    label: 'GitHub',
                    svgAsset: 'assets/icons/github.svg',
                    onTap: () => _launchUrl('https://github.com/Si11-ibrahim'),
                    fullWidth:
                        isSmallScreen, // Only use full width for small screens
                  ),
                  SocialButton(
                    label: 'LinkedIn',
                    svgAsset: 'assets/icons/linkedin.svg',
                    onTap: () =>
                        _launchUrl('https://linkedin.com/in/Si11-ibrahim'),
                    fullWidth: isSmallScreen,
                  ),
                  SocialButton(
                    label: 'Instagram',
                    svgAsset: 'assets/icons/instagram.svg',
                    onTap: () => _launchUrl('https://instagram.com/si11_ibu'),
                    fullWidth: isSmallScreen,
                  ),
                  SocialButton(
                    label: 'X',
                    svgAsset: 'assets/icons/x.svg',
                    onTap: () => _launchUrl('https://x.com/Si11_ibrahim'),
                    fullWidth: isSmallScreen,
                  ),
                  SocialButton(
                    label: 'Medium',
                    svgAsset: 'assets/icons/medium.svg',
                    onTap: () =>
                        _launchUrl('https://medium.com/@ahamedibrahim0004'),
                    fullWidth: isSmallScreen,
                  ),
                  SocialButton(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    onTap: () =>
                        _launchUrl('mailto:s.ahmedibrahimsi11@gmail.com'),
                    fullWidth: isSmallScreen,
                  ),
                ],
              )
            else
              // Large screens - horizontal row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20, // Space between buttons
                children: [
                  SocialButton(
                    label: 'GitHub',
                    svgAsset: 'assets/icons/github.svg',
                    onTap: () => _launchUrl('https://github.com/Si11-ibrahim'),
                  ),
                  SocialButton(
                    label: 'LinkedIn',
                    svgAsset: 'assets/icons/linkedin.svg',
                    onTap: () =>
                        _launchUrl('https://linkedin.com/in/Si11-ibrahim'),
                  ),
                  SocialButton(
                    label: 'Instagram',
                    svgAsset: 'assets/icons/instagram.svg',
                    onTap: () => _launchUrl('https://instagram.com/si11_ibu'),
                  ),
                  SocialButton(
                    label: 'X',
                    svgAsset: 'assets/icons/x.svg',
                    onTap: () => _launchUrl('https://x.com/Si11_ibrahim'),
                  ),
                  SocialButton(
                    label: 'Medium',
                    svgAsset: 'assets/icons/medium.svg',
                    onTap: () =>
                        _launchUrl('https://medium.com/@ahamedibrahim0004'),
                  ),
                  SocialButton(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    onTap: () =>
                        _launchUrl('mailto:s.ahmedibrahimsi11@gmail.com'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
