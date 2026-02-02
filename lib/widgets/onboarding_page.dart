import 'package:flutter/material.dart';

class OnboardingData {
  final String image;
  final String title;
  final String titleHighlight;
  final String description;
  final String descriptionHighlight;
  final Color titleColor;
  final Color highlightColor;

  OnboardingData({
    required this.image,
    required this.title,
    required this.titleHighlight,
    required this.description,
    this.descriptionHighlight = '',
    required this.titleColor,
    required this.highlightColor,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  List<TextSpan> _buildDescriptionSpans() {
    if (data.descriptionHighlight.isEmpty) {
      return [
        TextSpan(
          text: data.description,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
      ];
    }

    final lower = data.description.toLowerCase();
    final highlight = data.descriptionHighlight.toLowerCase();
    final start = lower.indexOf(highlight);

    if (start == -1) {
      return [
        TextSpan(
          text: data.description,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
      ];
    }

    final end = start + data.descriptionHighlight.length;

    return [
      TextSpan(
        text: data.description.substring(0, start),
        style: const TextStyle(color: Color(0xFF6B7280)),
      ),
      TextSpan(
        text: data.description.substring(start, end),
        style: TextStyle(color: data.highlightColor),
      ),
      TextSpan(
        text: data.description.substring(end),
        style: const TextStyle(color: Color(0xFF6B7280)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            data.image,
            width: 240,
            height: 240,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: data.title, style: TextStyle(color: data.titleColor)),
                TextSpan(
                  text: data.titleHighlight,
                  style: TextStyle(color: data.highlightColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 16),
              children: _buildDescriptionSpans(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
