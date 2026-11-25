import 'dart:math' as math;
import 'package:flutter/material.dart';

enum WeatherType { sunny, cloudy, rainy, thunderstorm, snowy, foggy }

class AnimatedWeatherBackground extends StatefulWidget {
  final int weatherCode;
  final Widget child;

  const AnimatedWeatherBackground({
    super.key,
    required this.weatherCode,
    required this.child,
  });

  @override
  State<AnimatedWeatherBackground> createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimController;
  late AnimationController _lightningController;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  WeatherType get _weatherType {
    final code = widget.weatherCode;
    if (code == 0 || code == 1) return WeatherType.sunny;
    if (code == 2 || code == 3) return WeatherType.cloudy;
    if (code == 45 || code == 48) return WeatherType.foggy;
    if (code >= 51 && code <= 67 || code >= 80 && code <= 82) return WeatherType.rainy;
    if (code >= 71 && code <= 77 || code == 85 || code == 86) return WeatherType.snowy;
    if (code >= 95) return WeatherType.thunderstorm;
    return WeatherType.cloudy;
  }

  @override
  void initState() {
    super.initState();
    _mainAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _initParticles();
    _startThunderstormTrigger();
  }

  void _initParticles() {
    _particles.clear();
    final count = (_weatherType == WeatherType.rainy || _weatherType == WeatherType.thunderstorm)
        ? 65
        : (_weatherType == WeatherType.snowy ? 45 : 25);

    for (int i = 0; i < count; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 3 + 1.5,
          speed: _random.nextDouble() * 0.008 + 0.004,
          opacity: _random.nextDouble() * 0.7 + 0.3,
          length: _random.nextDouble() * 18 + 12,
        ),
      );
    }
  }

  void _startThunderstormTrigger() {
    if (_weatherType == WeatherType.thunderstorm) {
      Future.delayed(Duration(seconds: _random.nextInt(4) + 3), () {
        if (mounted && _weatherType == WeatherType.thunderstorm) {
          _lightningController.forward().then((_) => _lightningController.reverse());
          _startThunderstormTrigger();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedWeatherBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCode != widget.weatherCode) {
      _initParticles();
      _startThunderstormTrigger();
    }
  }

  @override
  void dispose() {
    _mainAnimController.dispose();
    _lightningController.dispose();
    super.dispose();
  }

  List<Color> get _backgroundGradient {
    switch (_weatherType) {
      case WeatherType.sunny:
        return const [
          Color(0xFF0F4C81),
          Color(0xFF1B629B),
          Color(0xFFE28435),
          Color(0xFFE8A857),
        ];
      case WeatherType.cloudy:
        return const [
          Color(0xFF1F2833),
          Color(0xFF2C3949),
          Color(0xFF435A6E),
          Color(0xFF5B7A94),
        ];
      case WeatherType.rainy:
        return const [
          Color(0xFF0B192C),
          Color(0xFF1E3E62),
          Color(0xFF2C5364),
          Color(0xFF3B6780),
        ];
      case WeatherType.thunderstorm:
        return const [
          Color(0xFF070B19),
          Color(0xFF0F172A),
          Color(0xFF1E293B),
          Color(0xFF334155),
        ];
      case WeatherType.snowy:
        return const [
          Color(0xFF1C2A39),
          Color(0xFF384E66),
          Color(0xFF6B8CA8),
          Color(0xFFADC4D6),
        ];
      case WeatherType.foggy:
        return const [
          Color(0xFF232B32),
          Color(0xFF37434D),
          Color(0xFF576875),
          Color(0xFF7B8D99),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainAnimController, _lightningController]),
      builder: (context, _) {
        final lightningAlpha = _lightningController.value * 0.45;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. Lapisan Gradien Langit Dinamis
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _backgroundGradient,
                ),
              ),
            ),

            // 2. Kilatan Petir (jika badai petir)
            if (lightningAlpha > 0)
              Container(
                color: Colors.white.withValues(alpha: lightningAlpha),
              ),

            // 3. Elemen Langit Khusus (Matahari / Awan Berjalan)
            if (_weatherType == WeatherType.sunny)
              _buildSunnyEffects()
            else if (_weatherType == WeatherType.cloudy || _weatherType == WeatherType.foggy)
              _buildCloudyEffects(),

            // 4. Custom Painter Partikel (Hujan, Salju, atau Butiran Debu Cahaya)
            CustomPaint(
              painter: _WeatherParticlePainter(
                weatherType: _weatherType,
                particles: _particles,
                progress: _mainAnimController.value,
              ),
            ),

            // 5. Konten Utama (Scrollable Child)
            widget.child,
          ],
        );
      },
    );
  }

  Widget _buildSunnyEffects() {
    final rotation = _mainAnimController.value * 2 * math.pi;

    return Positioned(
      top: 40,
      right: 30,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.amber.withValues(alpha: 0.9),
                Colors.orangeAccent.withValues(alpha: 0.4),
                Colors.transparent,
              ],
              stops: const [0.3, 0.65, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloudyEffects() {
    final progress = _mainAnimController.value;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Awan Layer 1 (Lambat di latar belakang)
        Positioned(
          top: 70,
          left: (progress * (screenWidth + 260)) - 200,
          child: Opacity(
            opacity: 0.18,
            child: Icon(
              Icons.cloud_rounded,
              size: 240,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        // Awan Layer 2 (Lebih cepat di depan)
        Positioned(
          top: 130,
          left: ((progress * 1.5) % 1.0) * (screenWidth + 300) - 250,
          child: Opacity(
            opacity: 0.12,
            child: Icon(
              Icons.cloud_queue_rounded,
              size: 190,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double length;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.length,
  });
}

class _WeatherParticlePainter extends CustomPainter {
  final WeatherType weatherType;
  final List<_Particle> particles;
  final double progress;

  _WeatherParticlePainter({
    required this.weatherType,
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (weatherType == WeatherType.sunny) {
      // Efek partikel cahaya matahari mengambang (Sun Dust / Bokeh)
      final paint = Paint()..style = PaintingStyle.fill;
      for (var p in particles) {
        final currentY = (p.y - progress * p.speed * 8) % 1.0;
        final currentX = (p.x + math.sin(progress * 2 * math.pi + p.y * 10) * 0.03) % 1.0;
        paint.color = Colors.amberAccent.withValues(alpha: p.opacity * 0.35);
        canvas.drawCircle(
          Offset(currentX * size.width, currentY * size.height),
          p.size * 1.8,
          paint,
        );
      }
    } else if (weatherType == WeatherType.rainy || weatherType == WeatherType.thunderstorm) {
      // Efek rintik garis hujan jatuh miring
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: 0.45)
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round;

      for (var p in particles) {
        final currentY = (p.y + progress * p.speed * 50) % 1.0;
        final startX = p.x * size.width;
        final startY = currentY * size.height;
        final endX = startX - 4;
        final endY = startY + p.length;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint..color = Colors.white.withValues(alpha: p.opacity * 0.5),
        );
      }
    } else if (weatherType == WeatherType.snowy) {
      // Efek butiran salju melayang bergoyang
      final paint = Paint()..style = PaintingStyle.fill;
      for (var p in particles) {
        final currentY = (p.y + progress * p.speed * 12) % 1.0;
        final sway = math.sin(progress * 4 * math.pi + p.y * 8) * 0.04;
        final currentX = (p.x + sway) % 1.0;

        paint.color = Colors.white.withValues(alpha: p.opacity * 0.85);
        canvas.drawCircle(
          Offset(currentX * size.width, currentY * size.height),
          p.size * 1.4,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WeatherParticlePainter oldDelegate) => true;
}
