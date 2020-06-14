import 'dart:ui';

import 'package:flutter/material.dart';
import 'auto_sprite.dart';

class Award extends AutoSprite {
  Award() {
    this.speed = 4;
    this.size = Size(58, 88);
  }

  @override
  Widget getRenderWidget() {
    return Positioned(
      left: this.x,
      top: this.y,
      child: Image.asset(
        'assets/imgs/ufo1.png',
        width: this.size.width,
        height: this.size.height,
      ),
    );
  }
}
