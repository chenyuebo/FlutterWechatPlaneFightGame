import 'auto_sprite.dart';
import 'package:flutter/material.dart';

class Explosion extends AutoSprite {
  List<String> imgs;

  Explosion(this.imgs);

  @override
  void update() {
    super.update();
    if (getImgIndex() >= this.imgs.length) {
      destroyed = true;
    }
  }

  int getImgIndex() {
    return this.flame ~/ 5;
  }

  @override
  Widget getRenderWidget() {
    return Positioned(
      left: this.x,
      top: this.y,
      child: Image.asset(
        this.imgs[getImgIndex()],
        width: this.size.width,
        height: this.size.height,
      ),
    );
  }
}
