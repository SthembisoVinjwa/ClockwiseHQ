import 'package:flutter/material.dart';

class ArrowTextWidget extends StatefulWidget {
  final List<String> texts;
  final Function(String) onUpdateText;
  int index;
  Color textColor;

  ArrowTextWidget({super.key, required this.texts, required this.onUpdateText, required this.index, required this.textColor});

  @override
  _ArrowTextWidgetState createState() => _ArrowTextWidgetState();
}

class _ArrowTextWidgetState extends State<ArrowTextWidget> {
  late int _index = widget.index;

  void _incrementIndex() {
    setState(() {
      _index = (_index + 1) % widget.texts.length;
      widget.onUpdateText(widget.texts[_index]);
    });
  }

  void _decrementIndex() {
    setState(() {
      _index = (_index - 1 + widget.texts.length) % widget.texts.length;
      widget.onUpdateText(widget.texts[_index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: _decrementIndex,
          icon: Icon(Icons.arrow_left, color: widget.textColor),
          color: widget.textColor,
        ),
        const SizedBox(width: 16.0),
        Text(
          widget.texts[_index],
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: widget.textColor),
        ),
        const SizedBox(width: 16.0),
        IconButton(
          onPressed: _incrementIndex,
          icon: Icon(Icons.arrow_right, color: widget.textColor,),
          color: widget.textColor,
        ),
      ],
    );
  }
}