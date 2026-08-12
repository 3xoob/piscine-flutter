import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

void main() {
  runApp(const BouncerApp());
}

class BouncerApp extends StatelessWidget {
  const BouncerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
        ),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _width = 0;
  double _height = 0;

  // Ball
  final double _ballRadius = 10;
  Offset _ballPosition = Offset.zero;
  Offset _ballVelocity = const Offset(150, -200); // px per second

  // Paddle
  final double _paddleWidth = 80;
  final double _paddleHeight = 16;
  double _paddleX = 0;

  // Blocks
  final List<Rect> _blocks = [];

  // Game state
  bool _isRunning = false;
  String? _gameMessage;

  // Accelerometer
  StreamSubscription<SensorEvent>? _sensorSubscription;
  double _tiltX = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _initSensors();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _sensorSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initSensors() async {
    // Accelerometer not used on web; skip to allow web builds.
    if (kIsWeb) return;

    final available = await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
    if (!available) {
      return;
    }

    final stream =
        await SensorManager().sensorUpdates(sensorId: Sensors.ACCELEROMETER);

    _sensorSubscription = stream.listen((event) {
      final data = event.data;
      // data[0] is usually X axis (left/right tilt)
      setState(() {
        _tiltX = data[0];
      });
    });
  }

  void _movePaddleTo(double x) {
    final minX = _paddleWidth / 2;
    final maxX = _width - _paddleWidth / 2;
    setState(() {
      _paddleX = x.clamp(minX, maxX);
    });
  }

  void _startGame() {
    setState(() {
      _resetLevel();
      _isRunning = true;
      _gameMessage = null;
    });
    _ticker.start();
  }

  void _resetLevel() {
    _ballPosition = Offset(_width / 2, _height * 0.6);
    _ballVelocity = const Offset(150, -200);
    _paddleX = _width / 2;
    _blocks
      ..clear()
      ..addAll(_createBlocks());
  }

  List<Rect> _createBlocks() {
    const rows = 4;
    const cols = 6;
    const blockHeight = 20.0;
    const verticalSpacing = 8.0;
    const horizontalSpacing = 8.0;

    final List<Rect> blocks = [];
    final totalSpacingWidth = (cols + 1) * horizontalSpacing;
    final blockWidth = (_width - totalSpacingWidth) / cols;

    double top = 60;
    for (int row = 0; row < rows; row++) {
      double left = horizontalSpacing;
      for (int col = 0; col < cols; col++) {
        blocks.add(
          Rect.fromLTWH(left, top, blockWidth, blockHeight),
        );
        left += blockWidth + horizontalSpacing;
      }
      top += blockHeight + verticalSpacing;
    }
    return blocks;
  }

  void _onTick(Duration elapsed) {
    if (!_isRunning || _width == 0 || _height == 0) return;

    const dt = 1 / 60.0;

    // Update paddle based on tilt
    // Map tiltX to horizontal velocity
    final paddleSpeed = -_tiltX * 200; // negative so tilt right moves paddle right
    _paddleX += paddleSpeed * dt;
    final minX = _paddleWidth / 2;
    final maxX = _width - _paddleWidth / 2;
    _paddleX = _paddleX.clamp(minX, maxX);

    // Update ball position
    Offset newPosition = _ballPosition +
        Offset(_ballVelocity.dx * dt, _ballVelocity.dy * dt);

    Offset newVelocity = _ballVelocity;

    // Wall collisions
    if (newPosition.dx - _ballRadius <= 0 && newVelocity.dx < 0) {
      newVelocity = Offset(-newVelocity.dx, newVelocity.dy);
      newPosition = Offset(_ballRadius, newPosition.dy);
    } else if (newPosition.dx + _ballRadius >= _width && newVelocity.dx > 0) {
      newVelocity = Offset(-newVelocity.dx, newVelocity.dy);
      newPosition = Offset(_width - _ballRadius, newPosition.dy);
    }

    if (newPosition.dy - _ballRadius <= 0 && newVelocity.dy < 0) {
      newVelocity = Offset(newVelocity.dx, -newVelocity.dy);
      newPosition = Offset(newPosition.dx, _ballRadius);
    }

    // Paddle collision
    // Place paddle close to the bottom of the game area
    final paddleTop = _height - _paddleHeight - 10;
    final paddleRect = Rect.fromCenter(
      center: Offset(_paddleX, paddleTop + _paddleHeight / 2),
      width: _paddleWidth,
      height: _paddleHeight,
    );
    final ballRect = Rect.fromCircle(center: newPosition, radius: _ballRadius);
    // Slightly expand hitbox to make collisions more forgiving
    final expandedPaddleRect = paddleRect.inflate(20);

    if (ballRect.overlaps(expandedPaddleRect) && _ballVelocity.dy > 0) {
      // Reflect vertically
      newVelocity = Offset(newVelocity.dx, -newVelocity.dy);

      // Add a bit of angle based on where it hits the paddle
      final hitOffset = (newPosition.dx - paddleRect.center.dx) / (_paddleWidth / 2);
      newVelocity = Offset(
        newVelocity.dx + 80 * hitOffset,
        newVelocity.dy,
      );

      // Move ball above paddle to avoid sticking
      newPosition = Offset(newPosition.dx, paddleRect.top - _ballRadius);
    }

    // Block collisions
    Rect? hitBlock;
    for (final block in _blocks) {
      if (ballRect.overlaps(block)) {
        hitBlock = block;
        break;
      }
    }

    if (hitBlock != null) {
      _blocks.remove(hitBlock);

      // Determine side of collision: compare overlap in x vs y
      final dx = min(ballRect.right - hitBlock.left,
              hitBlock.right - ballRect.left)
          .clamp(0.0, double.infinity);
      final dy = min(ballRect.bottom - hitBlock.top,
              hitBlock.bottom - ballRect.top)
          .clamp(0.0, double.infinity);

      if (dx < dy) {
        // Hit vertical side - reflect horizontally
        newVelocity = Offset(-newVelocity.dx, newVelocity.dy);
      } else {
        // Hit horizontal side - reflect vertically
        newVelocity = Offset(newVelocity.dx, -newVelocity.dy);
      }
    }

    // Check lose condition: ball touches bottom
    if (newPosition.dy - _ballRadius > _height) {
      _isRunning = false;
      _gameMessage = 'You lost!';
      _ticker.stop();
    }

    // Check win condition: all blocks destroyed
    if (_blocks.isEmpty && _isRunning) {
      _isRunning = false;
      _gameMessage = 'You won!';
      _ticker.stop();
    }

    setState(() {
      _ballPosition = newPosition;
      _ballVelocity = newVelocity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bouncer'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _width = constraints.maxWidth;
          _height = constraints.maxHeight;

          if (!_isRunning &&
              _gameMessage == null &&
              _width > 0 &&
              _height > 0) {
            _resetLevel();
          }

          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              _movePaddleTo(details.localPosition.dx);
            },
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(_width, _height),
                  painter: _GamePainter(
                    ballPosition: _ballPosition,
                    ballRadius: _ballRadius,
                    paddleX: _paddleX,
                    paddleWidth: _paddleWidth,
                    paddleHeight: _paddleHeight,
                    blocks: _blocks,
                  ),
                ),
                if (!_isRunning)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_gameMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              _gameMessage!,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: _startGame,
                          child: const Text('Start'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GamePainter extends CustomPainter {
  final Offset ballPosition;
  final double ballRadius;
  final double paddleX;
  final double paddleWidth;
  final double paddleHeight;
  final List<Rect> blocks;

  _GamePainter({
    required this.ballPosition,
    required this.ballRadius,
    required this.paddleX,
    required this.paddleWidth,
    required this.paddleHeight,
    required this.blocks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background
    paint.color = const Color(0xFF0F172A);
    canvas.drawRect(Offset.zero & size, paint);

    // Blocks
    paint.color = Colors.orangeAccent;
    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(4)),
        paint,
      );
    }

    // Paddle (same vertical position as in game logic)
    final paddleTop = size.height - paddleHeight - 10;
    final paddleRect = Rect.fromCenter(
      center: Offset(paddleX, paddleTop + paddleHeight / 2),
      width: paddleWidth,
      height: paddleHeight,
    );
    paint.color = Colors.lightBlueAccent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(paddleRect, const Radius.circular(8)),
      paint,
    );

    // Ball
    paint.color = Colors.white;
    canvas.drawCircle(ballPosition, ballRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _GamePainter oldDelegate) {
    return ballPosition != oldDelegate.ballPosition ||
        paddleX != oldDelegate.paddleX ||
        blocks.length != oldDelegate.blocks.length;
  }
}
