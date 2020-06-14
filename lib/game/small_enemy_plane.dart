import 'dart:ui';
import 'package:flutter/material.dart';
import 'enemy_plane.dart';

import 'explosion.dart';
import 'game.dart';

class SmallEnemyPlane extends EnemyPlane {
  SmallEnemyPlane() {
    this.power = 2;
    this.speed = 5;
    this.value = 1000;
    this.size = Size(51, 39);
    collideOffset = 5;
  }

  @override
  Widget getRenderWidget() {
    return Positioned(
      left: this.x,
      top: this.y,
      child: Image.asset(
        'assets/imgs/enemy1.png',
        width: this.size.width,
        height: this.size.height,
      ),
    );
  }

  @override
  void explode(Game game) {
    Explosion explosion = Explosion([
      'assets/imgs/enemy1_down1.png',
      'assets/imgs/enemy1_down2.png',
      'assets/imgs/enemy1_down3.png',
      'assets/imgs/enemy1_down4.png',
    ]);
    explosion.x = this.x;
    explosion.y = this.y;
    explosion.speed = 0.5;
    explosion.size = this.size;
    game.addExplosion(explosion);
  }
}
