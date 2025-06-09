import 'package:flutter/material.dart';
import 'package:makeeasy/pages/HomePage.dart';

class FilterSelector extends StatefulWidget {
  const FilterSelector({
    super.key,
    required this.optionChangeHandler,
    required this.categoryFilter,
    required this.optionChosenHandler,
  });

  final Function(int) optionChangeHandler;
  final Function(int) optionChosenHandler;
  final CategoryFilter categoryFilter;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  // Controller to manage the PageView's position
  late final PageController _pageController;
  // The currently selected page index
  int _currentPage = 0;
  // State for the heart button
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    // Initialize the PageController.
    // viewportFraction allows us to see adjacent items.
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction:
          0.25, // Adjust this value to show more/less of the next/prev items
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
    // A Stack lets us place the heart icon on top of the PageView area.
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Positioned(
          right: 16,
          bottom: 64,
          child: IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color:
                  _isFavorited
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
              size: 32,
            ),
            onPressed: () {
              // Toggle the favorite state when the button is clicked
              setState(() {
                _isFavorited = !_isFavorited;
              });
            },
          ),
        ),

        SizedBox(height: 8),

        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 3. The swipeable list of filter circles
            SizedBox(
              height: 100, // Provide a fixed height for the PageView container
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.categoryFilter == CategoryFilter.All ? 2 : 1,
                // This callback is fired when the user swipes to a new page
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                    // You might want to reset the favorite status per filter
                    // For this example, we keep a single favorite state.
                  });
                  widget.optionChangeHandler(page);
                },
                itemBuilder: (context, index) {
                  String filterImageName =
                      widget.categoryFilter == CategoryFilter.Party
                          ? 'party'
                          : (index == 0 ? 'daily' : 'party');
                  // We use an AnimatedBuilder to create a scaling effect
                  // for the centered item.
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double scaleValue = 1.0;
                      double translateY = 0.0;

                      if (_pageController.position.haveDimensions) {
                        // Get the difference between the current page and the item's index
                        double pageValue =
                            (_pageController.page ?? 0.0) - index;

                        // Calculate the scale. It's 1.0 for the center item, 0.5 for others.
                        // We use clamp to ensure the value stays within the 0.5-1.0 range.
                        scaleValue = (1 - (pageValue.abs() * 0.5)).clamp(
                          0.5,
                          1.0,
                        );

                        // Calculate the vertical translation.
                        // It's -30 (upwards) for the center item, and 0 for others.
                        // We use ease-out curve for a smoother transition.
                        double verticalOffset =
                            1 -
                            Curves.easeOut.transform(
                              pageValue.abs().clamp(0.0, 1.0).toDouble(),
                            );
                        translateY = -60 * verticalOffset.clamp(0.0, 1.0);
                      }

                      // Use a single Transform widget with Matrix4 to combine scale and translation.
                      return Transform(
                        transform: Matrix4.identity()..scale(scaleValue),
                        // ..translate(
                        //   0.0,
                        //   translateY,
                        // ), // Apply vertical translation
                        // Apply scale
                        alignment:
                            Alignment
                                .center, // Ensure scaling happens from the center
                        child: child,
                      );
                    },
                    // This is the child that the builder will transform
                    child: GestureDetector(
                      onTap: () {
                        widget.optionChosenHandler(
                          widget.categoryFilter == CategoryFilter.Party
                              ? 1
                              : index,
                        );
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
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

            // 4. The Heart Button
          ],
        ),
      ],
    );
  }
}
