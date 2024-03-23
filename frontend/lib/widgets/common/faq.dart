import 'package:flutter/material.dart';

class FaqItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool? isFinal;

  const FaqItem({
    required this.icon,
    this.isFinal,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(left: 30),
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
        if (isFinal == true) const SizedBox() else const Divider(),
      ],
    );
  }
}
