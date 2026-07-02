import 'package:flutter/material.dart';

class CustomNumberButton extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Color color;
  final ValueChanged<int> onChanged;
  final int decimalPlaces;

  CustomNumberButton({
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.color,
    required this.onChanged,
    this.decimalPlaces = 0,
  });

  @override
  _CustomNumberButtonState createState() => _CustomNumberButtonState();
}

class _CustomNumberButtonState extends State<CustomNumberButton> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
        widget.onChanged(_currentValue);
      });
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
        widget.onChanged(_currentValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          color: widget.color,
          onPressed: _decrement,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _currentValue.toString(),
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          color: widget.color,
          onPressed: _increment,
        ),
      ],
    );
  }
}
