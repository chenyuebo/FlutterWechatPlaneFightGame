import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'bullet.dart';
import 'explosion.dart';
import 'sprite.dart';

import 'game.dart';

class CombatAircraft extends Sprite {
  /// 是否为单发子弹
  bool single = true;
  var awardTime = 180;
  var bullets = <Bullet>[];

  CombatAircraft() {
    this.size = Size(100, 124);
    collideOffset = 20;
  }

  @override
  void update() {
    if (awardTime > 0) {
      awardTime--;
    }
    if (awardTime <= 0) {
      single = true;
    }
    super.update();
    if (!destroyed && flame % 7 == 0) {
      if (single) {
        var bullet = Bullet('assets/imgs/bullet1.png');
        bullet.centerTo(this.x + this.size.width / 2, this.y);
        bullets.add(bullet);
      } else {
        var bullet = Bullet('assets/imgs/bullet2.png');
        bullet.centerTo(this.x + this.size.width / 2 - 10, this.y);
        bullets.add(bullet);

        var bullet2 = Bullet('assets/imgs/bullet2.png');
        bullet2.centerTo(this.x + this.size.width / 2 + 10, this.y);
        bullets.add(bullet2);
      }
    }
  }

  @override
  Widget getRenderWidget() {
    var img = 'assets/imgs/hero1.png';
    return Positioned(
      top: this.y,
      left: this.x,
      child: Container(
        child: (flame % 10) < 5
            ? Image.asset(
                'assets/imgs/hero1.png',
                height: this.size.height,
                width: this.size.width,
              )
            : Image.asset(
                'assets/imgs/hero2.png',
                height: this.size.height,
                width: this.size.width,
              ),
      ),
    );
  }

  List<Bullet> getBullets() {
    var list = bullets;
    bullets = <Bullet>[];
    return list;
  }

  void addAward() {
    single = false;
    awardTime = 300;
  }

  void explose(Game game) {
    Explosion explosion = Explosion([
      'assets/imgs/hero_blowup_n1.png',
      'assets/imgs/hero_blowup_n2.png',
      'assets/imgs/hero_blowup_n3.png',
      'assets/imgs/hero_blowup_n4.png',
    ]);
    explosion.x = this.x;
    explosion.y = this.y;
    explosion.size = this.size;
    if (!destroyed) {
      game.addExplosion(explosion);
      destroyed = true;
    }
  }
}
