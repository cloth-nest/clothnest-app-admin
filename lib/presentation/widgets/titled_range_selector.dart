import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery/data/utils/utils.dart';

class TitledRangeSelector extends StatefulWidget {
  const TitledRangeSelector({
    super.key,
    required this.onChanged,
    this.title = "",
    this.caption = "",
    this.range = const RangeValues(0, 100),
  });

  final String title;
  final String caption;
  final Duration titleToSelectorSwitch = const Duration(seconds: 2);
  final RangeValues range;
  final Function(RangeValues) onChanged;

  @override
  State<TitledRangeSelector> createState() => _TitledRangeSelectorState();
}

class _TitledRangeSelectorState extends State<TitledRangeSelector> {
  bool _titleVisible = true;
  RangeValues _values = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();

    _values = widget.range;

    Timer(
        widget.titleToSelectorSwitch,
        () => setState(() {
              _titleVisible = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerLeft, children: [
      AnimatedOpacity(
          opacity: _titleVisible ? 1 : 0,
          duration: const Duration(milliseconds: 1000),
          child: Align(
              alignment: Alignment.centerLeft, child: Text(widget.title))),
      AnimatedOpacity(
          opacity: _titleVisible ? 0 : 1,
          duration: const Duration(milliseconds: 1000),
          child: SizedBox(
              width: 340,
              child: Theme(
                  data: blackSlider(context),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _values.start.toStringAsFixed(0),
                                      ),
                                      Text(
                                        widget.caption,
                                      ),
                                      Text(
                                        _values.end.toStringAsFixed(0),
                                      )
                                    ]))),
                        SizedBox(
                            height: 24,
                            child: RangeSlider(
                              values: _values,
                              divisions: 9,
                              min: widget.range.start,
                              max: widget.range.end,
                              onChanged: (v) {
                                setState(() {
                                  _values = v;
                                });
                                widget.onChanged(v);
                              },
                            ))
                      ]))))
    ]);
  }
}
