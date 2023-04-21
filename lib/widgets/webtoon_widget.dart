import 'package:flutter/material.dart';
import 'package:webtoon/screens/detail_screen.dart';

class WebToon extends StatelessWidget {
  final String title, thumb, id;

  const WebToon(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id),
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    offset: const Offset(2, 3),
                    color: Colors.black.withOpacity(0.4),
                  )
                ],
              ),
              clipBehavior: Clip.hardEdge,
              width: 180,
              child: Image.network(thumb),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
