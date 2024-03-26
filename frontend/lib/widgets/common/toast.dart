import 'package:flutter/material.dart';

class ToastMsg extends StatelessWidget {
  const ToastMsg(
      {super.key, required this.text, required this.bgColor, this.icondata});
  final String text;
  final Color bgColor;
  final IconData? icondata;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icondata != null ? Icon(icondata) : const SizedBox(),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
