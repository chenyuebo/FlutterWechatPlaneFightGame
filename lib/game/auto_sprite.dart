import 'sprite.dart';

class AutoSprite extends Sprite {
  double speed = 2;

  @override
  void update() {
    super.update();
    if (!destroyed) {
      move(0, speed);
    } else {
    }
  }


}
