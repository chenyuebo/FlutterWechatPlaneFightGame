import 'package:flutter/cupertino.dart';
import 'enemy_plane.dart';
import 'explosion.dart';

import 'game.dart';

class MiddleEnemyPlane extends EnemyPlane {
  MiddleEnemyPlane() {
    this.power = 4;
    this.speed = 4;
    this.value = 5000;
    this.size = Size(69, 89);
    collideOffset = 5;
  }

  @override
  Widget getRenderWidget() {
    return Positioned(
      left: this.x,
      top: this.y,
      child: Image.asset(
        'assets/imgs/enemy2.png',
        width: 69,
        height: 89,
      ),
    );
  }

  @override
  void explode(Game game) {
    Explosion explosion = Explosion([
      'assets/imgs/enemy2_down1.png',
      'assets/imgs/enemy2_down2.png',
      'assets/imgs/enemy2_down3.png',
      'assets/imgs/enemy2_down4.png',
    ]);
    explosion.x = this.x;
    explosion.y = this.y;
    explosion.speed = 0.5;
    explosion.size = this.size;
    game.addExplosion(explosion);
  }
}
