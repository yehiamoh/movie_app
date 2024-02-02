import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/search_category.dart';
import 'package:movie_app/services/movie_service.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData? state])
      : super(state ?? MainPageData.intial()) {
    getMovies();
  }
  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie>? _movies = [];
      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await (_movieService.getPopularMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await (_movieService.getUpComingMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        } else {
          _movies = await (_movieService.searchMovies(state.searchText));
        }
      }

      state = state.copywith(
          movies: [...state.movies!, ..._movies!], page: state.page! + 1);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String _category) {
    try {
      state =
          state.copywith(movies: [], searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {}
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copywith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: _searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
