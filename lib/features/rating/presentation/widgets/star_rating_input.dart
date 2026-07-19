import 'package:flutter/material.dart';

class StarRatingInput extends StatefulWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final double starSize;

  const StarRatingInput({
    super.key,
    this.rating = 0,
    required this.onRatingChanged,
    this.starSize = 32,
  });

  @override
  State<StarRatingInput> createState() => _StarRatingInputState();
}

class _StarRatingInputState extends State<StarRatingInput> {
  late int _rating;
  int _hoverRating = 0;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating;
  }

  @override
  void didUpdateWidget(StarRatingInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rating != oldWidget.rating) {
      _rating = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starNumber = index + 1;
        final isFilled = starNumber <= (_hoverRating > 0 ? _hoverRating : _rating);

        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = starNumber;
            });
            widget.onRatingChanged(starNumber);
          },
          child: Padding(
            padding: EdgeInsets.only(right: index < 4 ? 4 : 0),
            child: AnimatedScale(
              scale: _hoverRating == starNumber ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoverRating = starNumber),
                onExit: (_) => setState(() => _hoverRating = 0),
                child: Icon(
                  isFilled ? Icons.star : Icons.star_border,
                  size: widget.starSize,
                  color: isFilled
                      ? const Color(0xFF705A4E)
                      : const Color(0xFFCDC4CA),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
