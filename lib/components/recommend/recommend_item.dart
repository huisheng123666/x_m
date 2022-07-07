import 'package:flutter/material.dart';
import 'package:x_m/models/movie.dart';
import 'package:x_m/util.dart';

class RecommendItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTab;

  const RecommendItem({super.key, required this.movie, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab ?? (() {}),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Container(
              height: Util.screenWidth(context) * 0.44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movie.cover),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                width: Util.screenWidth(context),
                color: const Color.fromRGBO(0, 0, 0, 0.3),
                child: Opacity(
                  opacity: 0.9,
                  child: Image.asset(
                    'assets/icon/play.png',
                    width: 45,
                    height: 45,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 200,
                            child: Text(
                              movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xff010101),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: Util.calc(270, context),
                            child: Text(
                              '#${movie.category}  #${movie.language}  #${movie.area}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black38),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 48,
                        alignment: Alignment.topCenter,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icon/tag.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            '9.8',
                            style: TextStyle(
                              color: Color(0xff010101),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(
                      movie.intro,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
