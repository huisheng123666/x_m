import 'package:flutter/cupertino.dart';
import 'package:x_m/models/movie.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.movie,
    required this.ontap,
  }) : super(key: key);

  final Movie movie;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            movie.cover,
            width: double.infinity,
            height: 180,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, bottom: 2),
            child: Text(
              movie.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              movie.showTime,
              style: const TextStyle(
                color: Color(0xffb3b3b3),
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}
