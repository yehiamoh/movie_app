import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/movie.dart';

class MovieTile extends StatelessWidget {
  final GetIt getIt = GetIt.instance;
  final double? height;
  final double? width;
  final Movie? movie;
  MovieTile({this.height, this.movie, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_moviePosterWidget(movie!.posterURL()), _movieInfoWidget()],
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: width! * 0.699,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            /*  mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,*/
            children: [
              Container(
                width: width! * 0.56,
                child: Text(
                  movie!.name!,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                movie!.rating!.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, height! * 0.02, 0, 0),
              child: Text(
                "${movie!.language!.toUpperCase()} | R:${movie!.isAdult!}  | ${movie!.releaseDate!}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height! * 0.07, 0, 0),
            child: Text(
              movie!.description!,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String? _imageUrl) {
    return Container(
      height: height,
      width: width! * 0.35,
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(_imageUrl!))),
    );
  }
}
