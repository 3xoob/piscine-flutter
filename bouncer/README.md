# Bouncer

A simple accelerometer-controlled bouncing ball game built with Flutter.

The goal is to destroy all blocks with the ball while preventing it from touching the bottom of the screen. The paddle moves according to the phone's tilt.

## Features (Requirements)

- Ball moves linearly and bounces off:
  - Walls
  - Player paddle
  - Blocks
- Blocks disappear when hit by the ball
- Lose condition: ball touches the bottom → **"You lost!"**
- Win condition: all blocks destroyed → **"You won!"**
- Paddle movement:
  - Controlled by phone accelerometer (tilt left/right)
  - Clamped so it never leaves the screen

## Important Files

- `lib/main.dart`
  - Game loop using `Ticker`
  - Ball, paddle, and block physics/collisions
  - Accelerometer reading via `flutter_sensors`
  - Win/lose overlay with a Start button

## How to Run

From the project root:

```bash
cd bouncer
flutter pub get
flutter run
```

Run this on a real device or emulator with accelerometer support.  
Tilt the phone left/right to move the paddle and keep the ball from falling.

