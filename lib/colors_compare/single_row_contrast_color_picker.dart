import 'package:colorstudio/blocs/blocs.dart';
import 'package:colorstudio/blocs/multiple_contrast_compare/rgb_hsluv_tuple.dart';
import 'package:colorstudio/example/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../contrast_util.dart';

class SingleRowContrastColorPicker extends StatelessWidget {
  const SingleRowContrastColorPicker({
    @required this.colorsRange,
    @required this.currentKey,
  });

  final ColorType currentKey;
  final List<RgbHSLuvTupleWithContrast> colorsRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 0; i < colorsRange.length; i++)
              SizedBox(
                width: 56,
                height: 56,
                child: _ContrastItemCompacted(
                  rgbHsluvTuple: colorsRange[i],
                  contrast: colorsRange[i].contrast,
                  onPressed: () {
                    context.bloc<MdcSelectedBloc>().add(
                          MDCLoadEvent(
                            currentColor: colorsRange[i].rgbColor,
                            selected: currentKey,
                          ),
                        );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContrastItemCompacted extends StatelessWidget {
  const _ContrastItemCompacted({
    this.rgbHsluvTuple,
    this.contrast,
    this.onPressed,
  });

  final RgbHSLuvTupleWithContrast rgbHsluvTuple;
  final double contrast;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        (rgbHsluvTuple.hsluvColor.lightness < kLightnessThreshold)
            ? Colors.white.withOpacity(0.87)
            : Colors.black87;

    return SizedBox(
      width: 56,
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.zero,
        color: rgbHsluvTuple.rgbColor,
        shape: const RoundedRectangleBorder(),
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              rgbHsluvTuple.hsluvColor.lightness.round().toString(),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: textColor),
            ),
            Text(
              contrast.toStringAsPrecision(3),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 10, color: textColor),
            ),
            Text(
              getContrastLetters(contrast),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 8, color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
