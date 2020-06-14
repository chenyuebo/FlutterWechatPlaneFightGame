import 'dart:async';

import 'package:flutter/material.dart';

import 'game.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  double top = 0;
  double left = 0;

  Timer _timer;

  Game _game;

  @override
  void initState() {
    startLoop();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    endLoop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startLoop();
    } else if (state == AppLifecycleState.paused) {
      endLoop();
      if (_game != null) {
        _game.pause = true;
      }
    }
  }

  startLoop() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
        if (_game != null) {
          _game.update();
        }
        setState(() {});
      });
    }
  }

  endLoop() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      _game = Game();
      _game.size = MediaQuery.of(context).size;
      _game.startGame();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (details) {
        setState(() {
          if (details is DragUpdateDetails) {
            _game.move(details.delta.dx, details.delta.dy);
          }
        });
      },
      child: SizedBox(
        child: _game.getRenderWidget(),
      ),
    );
  }
}
