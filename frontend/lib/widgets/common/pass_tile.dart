import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class PassTile extends StatelessWidget {
  final String title;
  final String content;

  const PassTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              softWrap: false,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Adjust the height as needed
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactTile extends StatefulWidget {
  final String title;
  final String number;
  final bool isSelected;
  final Function(bool) onSelect;

  const ContactTile({
    required this.title,
    required this.number,
    required this.isSelected,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ContactTileState();
  }
}

class _ContactTileState extends State<ContactTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Toggle the selection when tapped
        widget.onSelect(!widget.isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ListTile(
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: widget.isSelected
                  ? const Color.fromARGB(255, 7, 161, 76)
                  : Colors.black, // Highlight if selected
            ),
          ),
          subtitle: Text(
            widget.number,
            style: TextStyle(
              fontSize: 15,
              color: widget.isSelected
                  ? const Color.fromARGB(255, 7, 161, 76)
                  : Colors.black,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async {
              await FlutterPhoneDirectCaller.callNumber(widget.number);
            },
          ),
        ),
      ),
    );
  }
}
