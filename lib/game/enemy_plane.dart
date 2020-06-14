import 'auto_sprite.dart';

import 'game.dart';

class EnemyPlane extends AutoSprite {
  /// 敌机的抗打击能力
  int power = 1;

  /// 打一个敌机的得分
  int value = 0;

  void getShot(int damage, Game game) {
    if (this.power > 0) {
      this.power -= damage;
      if (this.power <= 0) {
        this.speed = 0;
        this.destroyed = true;
        game.addScore(this.value);
        explode(game);
      }
    }
  }

  void explode(Game game) {

  }
}
