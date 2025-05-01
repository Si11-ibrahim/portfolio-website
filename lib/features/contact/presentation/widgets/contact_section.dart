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
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
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
            if (isSmallScreen)
              Column(
                children: [
                  SocialButton(
                    label: 'GitHub',
                    icon: Icons.code,
                    onTap: () => _launchUrl('https://github.com/Si11-ibrahim'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'LinkedIn',
                    icon: Icons.business,
                    onTap: () => _launchUrl('https://linkedin.com/in/Si11-ibrahim'),
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  SocialButton(
                    label: 'Email',
                    icon: Icons.email,
                    onTap: () => _launchUrl('mailto:s.ahmedibrahimsi11@gmail.com'),
                    fullWidth: true,
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    label: 'GitHub',
                    icon: Icons.code,
                    onTap: () => _launchUrl('https://github.com/Si11-ibrahim'),
                  ),
                  const SizedBox(width: 20),
                  SocialButton(
                    label: 'LinkedIn',
                    icon: Icons.business,
                    onTap: () => _launchUrl('https://linkedin.com/in/Si11-ibrahim'),
                  ),
                  const SizedBox(width: 20),
                  SocialButton(
                    label: 'Email',
                    icon: Icons.email,
                    onTap: () => _launchUrl('mailto:s.ahmedibrahimsi11@gmail.com'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
