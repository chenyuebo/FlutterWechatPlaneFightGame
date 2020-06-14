import 'package:flutter/cupertino.dart';
import 'auto_sprite.dart';

class Bullet extends AutoSprite {
  Bullet(String image) {
    this.image = image;
    this.speed = -8;
    this.size = Size(9, 21);
  }

  @override
  void update() {
    super.update();
  }

  @override
  Widget getRenderWidget() {
    return Positioned(
      top: this.y,
      left: this.x,
      child: Image.asset(
        this.image,
        width: this.size.width,
        height: this.size.height,
      ),
    );
  }
}
