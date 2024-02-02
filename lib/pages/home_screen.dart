import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/controllers/main_page_data_controller.dart';
import 'package:movie_app/models/main_page_data.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/search_category.dart';
import 'package:movie_app/widgets/movie_tile.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});
final selectedMoviePosterUrlProvider = StateProvider<String?>((ref) {
  final _movies = ref.watch(mainPageDataControllerProvider).movies!;
  _movies.length != 0 ? _movies[0].posterURL() : null;
});

class HomeScreen extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;
  MainPageDataController? _mainPageDataController;
  MainPageData? _mainPageData;

  TextEditingController? _searchTextFieldController;

  String? _selectedMoviePosterURL;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _searchTextFieldController = TextEditingController();
    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    _searchTextFieldController = TextEditingController();
    _searchTextFieldController!.text = _mainPageData!.searchText!;

    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            width: _deviceWidth,
            height: _deviceHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [_backGround(), _foreGroundWidgets()],
            ),
          ),
        ));
  }

  Widget _backGround() {
    return Container(
      height: this._deviceHeight,
      width: this._deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
            image: NetworkImage(
                'https://tse1.mm.bing.net/th?id=OIP.TQC4jdBCdGTJt_AEvWWEogHaK4&pid=Api&P=0&h=220'),
            fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _foreGroundWidgets() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, _deviceHeight!, 0, 0),
        width: _deviceWidth! * 0.90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _topBarWidget(),
            Container(
              height: _deviceHeight! * 0.83,
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.01),
              child: _moviesListViewWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_searchFieldWidget(), _categortSelectionWidget()],
      ),
    );
  }

  Widget _searchFieldWidget() {
    return Container(
      width: _deviceWidth! * 0.50,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) =>
            _mainPageDataController!.updateTextSearch(_input),
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white24,
            ),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: "search...."),
      ),
    );
  }

  Widget _categortSelectionWidget() {
    return DropdownButton(
      onChanged: (_value) => _value.toString().isNotEmpty
          ? _mainPageDataController!.updateSearchCategory(_value!)
          : null,
      value: _mainPageData!.searchCategory!,
      icon: Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      items: [
        DropdownMenuItem(
            value: SearchCategory.popular,
            child: Text(
              SearchCategory.popular!,
              style: TextStyle(color: Colors.white),
            )),
        DropdownMenuItem(
            value: SearchCategory.upcoming,
            child: Text(
              SearchCategory.upcoming!,
              style: TextStyle(color: Colors.white),
            )),
        DropdownMenuItem(
            value: SearchCategory.none,
            child: Text(
              SearchCategory.none!,
              style: TextStyle(color: Colors.white),
            ))
      ],
      dropdownColor: Colors.black38,
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }

  Widget _moviesListViewWidget() {
    final List<Movie> _movies = _mainPageData!.movies!;
    print(_movies);
    if (_movies.length != 0) {
      return NotificationListener(
          onNotification: (_onScrollNotification) {
            if (_onScrollNotification is ScrollEndNotification) {
              final _before = _onScrollNotification.metrics.extentBefore;
              final _max = _onScrollNotification.metrics.maxScrollExtent;
              if (_before == _max) {
                _mainPageDataController!.getMovies();
              }
              return false;
            }
            return false;
          },
          child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (BuildContext context, int _count) {
                return Padding(
                    child: GestureDetector(
                      onTap: () {},
                      child: MovieTile(
                        movie: _movies[_count],
                        height: _deviceHeight! * 0.20,
                        width: _deviceWidth! * 0.85,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: _deviceHeight! * 0.01, horizontal: 0));
              }));
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 243, 242, 239),
        ),
      );
    }
  }
}
