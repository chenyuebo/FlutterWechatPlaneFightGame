import 'dart:math';

import 'package:flutter/material.dart';
import 'award.dart';
import 'big_enemy_plane.dart';
import 'explosion.dart';
import 'small_enemy_plane.dart';

import 'bullet.dart';
import 'combat_aircraft.dart';
import 'enemy_plane.dart';
import 'middle_enemy_plane.dart';
import 'sprite.dart';

class Game {
  var _combatAircraft = CombatAircraft();
  var bullets = <Bullet>[];
  var enemies = <EnemyPlane>[];
  var explosions = <Explosion>[];
  var awards = <Award>[];
  var size = Size(0, 0);
  var random = Random();

  /// 游戏是否暂停
  var pause = false;

  /// 游戏是否结束
  var gameOver = false;
  var flame = 0;

  void startGame() {
    score = 0;
    pause = false;
    gameOver = false;
    _combatAircraft.destroyed = false;
    _combatAircraft.single = true;
    _combatAircraft.x = (this.size.width - _combatAircraft.size.width) / 2;
    _combatAircraft.y = this.size.height - _combatAircraft.size.height;
    enemies.clear();
    explosions.clear();
    bullets.clear();
    enemies.add(MiddleEnemyPlane());
  }

  void stopGame() {
    enemies.clear();
    explosions.clear();
    bullets.clear();
  }

  void update() {
    flame++;
    if (!pause) {
      _updateWorld();
    }
  }

  void move(double dx, double dy) {
    if (!pause) {
      var x = _combatAircraft.centerX + dx;
      var y = _combatAircraft.centerY + dy;
      if (x < 0) {
        x = 0.0;
      } else if (x > this.size.width) {
        x = this.size.width;
      }
      if (y < 0) {
        y = 0.0;
      } else if (y > this.size.height) {
        y = this.size.height;
      }
      _combatAircraft.centerTo(x, y);
    }
  }

  void _updateWorld() {
    _combatAircraft.update();
    enemies.forEach((enemyPlane) {
      enemyPlane.update();
    });
    var list = _combatAircraft.getBullets();
    if (list != null && list.isNotEmpty) {
      bullets.addAll(list);
    }
    for (int i = 0; i < enemies.length; i++) {
      EnemyPlane enemyPlane = enemies[i];
      if (enemyPlane.destroyed || isOutScreen(enemyPlane)) {
        enemies.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < bullets.length; j++) {
        Bullet bullet = bullets[j];
        if (enemyPlane.isCollide(bullet)) {
          enemyPlane.getShot(1, this);
          bullets.removeAt(j);
          j--;
        }
      }
      if (_combatAircraft.isCollide(enemyPlane)) {
        _combatAircraft.explose(this);
        gameOver = true;
      }
    }
    for (int i = 0; i < awards.length; i++) {
      Award award = awards[i];
      if (_combatAircraft.isCollide(award)) {
        _combatAircraft.addAward();
        awards.removeAt(i);
        i--;
      } else if (isOutScreen(award)) {
        awards.removeAt(i);
        i--;
      } else {
        award.update();
      }
    }
    for (int i = 0; i < explosions.length; i++) {
      explosions[i].update();
      if (explosions[i].destroyed) {
        explosions.removeAt(i);
        i--;
      }
    }
    if ((flame % 600) == 0) {
      createAward();
    }
    createEnemy();
    for (int i = 0; i < bullets.length; i++) {
      Bullet bullet = bullets[i];
      bullet.update();
      if (isOutScreen(bullet)) {
        bullets.removeAt(i);
        i--;
      }
    }
  }

  createEnemy() {
    if (enemies.length < 3) {
      var category = random.nextInt(3);
      EnemyPlane enemy;
      if (category == 0) {
        enemy = SmallEnemyPlane();
      } else if (category == 1) {
        enemy = MiddleEnemyPlane();
      } else if (category == 2) {
        enemy = BigEnemyPlane();
      }
      if (enemy != null) {
        enemy.y = -enemy.size.height;
        enemy.x = random.nextDouble() * size.width - enemy.size.width / 2;
        enemies.add(enemy);
      }
    }
  }

  void createAward() {
    Award award = Award();
    award.y = -award.size.height;
    award.x = random.nextDouble() * size.width - award.size.width / 2;
    awards.add(award);
  }

  bool isOutScreen(Sprite sprite) {
    Rect rect1 = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect rect2 = sprite.getRect();
    Rect rect = rect1.intersect(rect2);
    if (rect.width < 0 || rect.height < 0) {
      return true;
    }
    return false;
  }

  void addExplosion(Explosion explosion) {
    explosions.add(explosion);
  }

  Widget getRenderWidget() {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: getWidgets(),
      ),
    );
  }

  int score = 0;

  addScore(int score) {
    this.score += score;
  }

  List<Widget> getWidgets() {
    var list = <Widget>[];
    list.add(Image.asset(
      'assets/imgs/bg.jpg.png',
      fit: BoxFit.cover,
      width: size.width,
      height: size.height,
    ));
    enemies.forEach((enemyPlane) {
      list.add(enemyPlane.getRenderWidget());
    });
    explosions.forEach((explosion) {
      list.add(explosion.getRenderWidget());
    });
    awards.forEach((award) {
      list.add(award.getRenderWidget());
    });
    bullets.forEach((bullet) {
      list.add(bullet.getRenderWidget());
    });
    if (!_combatAircraft.destroyed) {
      list.add(_combatAircraft.getRenderWidget());
    }
    list.add(getPauseButtonWidget());
    list.add(getScoreWidget());
    if (pause || gameOver) {
      list.add(getDialogWidget());
    }
    return list;
  }

  Positioned getPauseButtonWidget() {
    return Positioned(
      top: 40,
      left: 20,
      child: GestureDetector(
        child: Image.asset(
          pause
              ? 'assets/imgs/game_pause_pressed.png'
              : 'assets/imgs/game_pause_nor.png',
          width: 30,
          height: 30,
        ),
        onPanDown: (detail) {
          pause = true;
          print('onPanDown');
        },
      ),
    );
  }

  Positioned getScoreWidget() {
    return Positioned(
      top: 42,
      left: 65,
      child: Text(
        '$score',
        style: TextStyle(
            fontSize: 22,
            color: Colors.black54,
            decoration: TextDecoration.none),
      ),
    );
  }

  Widget getDialogWidget() {
    var top = (size.height - 260) / 2;
    return Positioned(
      top: top,
      left: 30,
      right: 30,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD7DDDE),
          border: Border.all(color: Colors.black54, width: 2),
        ),
        child: Column(
          children: [
            Container(
              height: 70,
              alignment: Alignment.center,
              child: Text(
                '飞机大战分数',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black54,
                    decoration: TextDecoration.none),
              ),
            ),
            Divider(color: Colors.black54, height: 2, thickness: 2),
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Text(
                '$score',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black54,
                    decoration: TextDecoration.none),
              ),
            ),
            Divider(color: Colors.black54, height: 2, thickness: 2),
            Container(
              height: 70,
              alignment: Alignment.center,
              child: OutlineButton(
                padding: EdgeInsets.symmetric(horizontal: 40),
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2,
                ),
                onPressed: () {
                  if (pause) {
                    pause = false;
                  } else if (gameOver) {
                    startGame();
                  }
                },
                child: Text(
                  gameOver ? '重新开始' : '继续',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black54,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
