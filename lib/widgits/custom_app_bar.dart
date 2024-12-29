import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD8BC78),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.30),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 5,
        title: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: screenWidth < 360 ? 10 : 20),
            child: Text(
              "صلوات المسلم",
              style: TextStyle(
                fontSize: screenWidth < 360 ? 24 : 30,
                fontFamily: 'Amiri-Regular',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
