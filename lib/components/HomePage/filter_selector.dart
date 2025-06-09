import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HomePage.dart';

class FilterSelector extends StatefulWidget {
  final void Function(int) onToggleFavorite;
  final bool Function(int) isFavorite;
  final Function(int) optionChangeHandler;
  final Function(int) optionChosenHandler;
  final CategoryFilter categoryFilter;

  const FilterSelector({
    super.key,
    required this.optionChangeHandler,
    required this.categoryFilter,
    required this.optionChosenHandler,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.25,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFilterUi();
  }

  Widget _buildFilterUi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 64.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(
                widget.isFavorite(_currentPage)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.isFavorite(_currentPage)
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                size: 32,
              ),
              onPressed: () {
                widget.onToggleFavorite(_currentPage);
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 100,
              child: PageView.builder(
                controller: _pageController,
                itemCount:
                    widget.categoryFilter == CategoryFilter.All ? 2 : 1,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                  widget.optionChangeHandler(page);
                },
                itemBuilder: (context, index) {
                  String filterImageName =
                      widget.categoryFilter == CategoryFilter.Party
                          ? 'party'
                          : (index == 0 ? 'daily' : 'party');

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double scaleValue = 1.0;
                      if (_pageController.position.haveDimensions) {
                        double pageValue =
                            (_pageController.page ?? 0.0) - index;
                        scaleValue = (1 - (pageValue.abs() * 0.5))
                            .clamp(0.5, 1.0);
                      }
                      return Transform(
                        transform: Matrix4.identity()..scale(scaleValue),
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        widget.optionChosenHandler(
                          widget.categoryFilter == CategoryFilter.Party
                              ? 1
                              : index,
                        );
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      },
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/$filterImageName.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
