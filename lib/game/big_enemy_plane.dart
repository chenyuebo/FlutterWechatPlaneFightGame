import 'dart:ui';
import 'package:flutter/material.dart';
import 'enemy_plane.dart';

import 'explosion.dart';
import 'game.dart';

class BigEnemyPlane extends EnemyPlane {
  BigEnemyPlane() {
    this.power = 10;
    this.speed = 2;
    this.value = 25000;
    this.size = Size(165, 255);
    collideOffset = 10;
  }

  @override
  Widget getRenderWidget() {
    var img = (flame % 20) < 10
        ? 'assets/imgs/enemy3_n1.png'
        : 'assets/imgs/enemy3_n2.png';
    return Positioned(
      left: this.x,
      top: this.y,
      child: Image.asset(
        img,
        width: this.size.width,
        height: this.size.height,
      ),
    );
  }

  @override
  void explode(Game game) {
    Explosion explosion = Explosion([
      'assets/imgs/enemy3_down1.png',
      'assets/imgs/enemy3_down2.png',
      'assets/imgs/enemy3_down3.png',
      'assets/imgs/enemy3_down4.png',
      'assets/imgs/enemy3_down5.png',
      'assets/imgs/enemy3_down6.png',
    ]);
    explosion.x = this.x;
    explosion.y = this.y;
    explosion.speed = 0.5;
    explosion.size = this.size;
    game.addExplosion(explosion);
  }
}
