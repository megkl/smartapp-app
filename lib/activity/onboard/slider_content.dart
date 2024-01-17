import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';


class SliderContent extends StatelessWidget {
  const SliderContent({
    Key? key,
    this.image,
    this.title,
    this.text,
  }) : super(key: key);

  final String? image, title, text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Spacer(),
        Image(
          image: AssetImage("$image"),
          height: (270 / 896) * size.height,
        ),
        Spacer(),
        AutoSizeText(
          title ??'',
          maxLines: 1,
          maxFontSize: 24,
          style:kTextHeadBoldStyle.apply(color: primary),
        ),
        SizedBox(height: kDefaultPadding / 2),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 30.0,
                maxHeight: 190.0,
              ),
              child: AutoSizeText(
                text ??'',
                textAlign: TextAlign.center,
                maxLines: 6,
                minFontSize: 18,
                style:kTextHeadStyle.apply(color: primary),
              ),
            ))
      ],
    );
  }
}