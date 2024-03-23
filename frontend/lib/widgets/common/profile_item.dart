import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {super.key, required this.attribute, required this.value, this.iconData});

  final String attribute;
  final String value;
  final FaIcon? iconData;

  @override
  Widget build(BuildContext context) {
    TextStyle customFont = GoogleFonts.lato();

    return Container(
      // color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              children: [
                iconData ?? Icon(
                        Icons.person,
                        size: 25,
                      ),
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attribute,
                      style: customFont.copyWith(
                        color: Color.fromARGB(255, 25, 32, 42),
                        // color: Color.fromARGB(255, 112, 106, 106),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      value,
                      style: customFont.copyWith(
                        color: Color.fromARGB(255, 96, 102, 110),
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
