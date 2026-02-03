import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  List<TextSpan> _buildDescriptionSpans(OnboardingData data) {
    if (data.descriptionHighlight.isEmpty) {
      return [TextSpan(text: data.description)];
    }

    final parts = data.description.split(data.descriptionHighlight);
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: data.descriptionHighlight,
            style: TextStyle(
              color: data.highlightColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Image
          Image.asset(data.image, height: 250, fit: BoxFit.contain),
          const SizedBox(height: 32),
          // Title with highlighted word
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: data.titleColor,
                height: 1.2,
              ),
              children: [
                TextSpan(text: data.title),
                TextSpan(
                  text: data.titleHighlight,
                  style: TextStyle(color: data.highlightColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Description with highlighted word
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
              children: _buildDescriptionSpans(data),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
