import 'package:app/ui/auth/route/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _contentOpacity;
  late final Animation<double> _contentScale;
  late final Animation<double> _backgroundOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _contentOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 35,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 45),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 20,
      ),
    ]).animate(_controller);

    _contentScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 55),
    ]).animate(_controller);

    _backgroundOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.35,
          end: 0.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(0.5), weight: 35),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.5,
          end: 0.35,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status != AnimationStatus.completed || !mounted) return;
      context.go(Routes.login.path);
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF09090B),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _backgroundOpacity,
            builder: (context, _) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Color.fromRGBO(39, 39, 42, _backgroundOpacity.value),
                      Color.fromRGBO(9, 9, 11, _backgroundOpacity.value),
                      Color.fromRGBO(9, 9, 11, _backgroundOpacity.value),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
                child: const SizedBox.expand(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: FadeTransition(
                opacity: _contentOpacity,
                child: ScaleTransition(
                  scale: _contentScale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _LogoBadge(),
                      SizedBox(height: 24),
                      Text(
                        'JITSU',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.2,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ACADEMY MANAGEMENT',
                        style: TextStyle(
                          color: Color(0xFF71717A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.4,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CustomPaint(
            painter: _GiIconPainter(color: const Color(0xFF09090B)),
          ),
        ),
      ),
    );
  }
}

class _GiIconPainter extends CustomPainter {
  final Color color;

  const _GiIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double scaleX = size.width / 24;
    final double scaleY = size.height / 24;

    Offset pt(double x, double y) => Offset(x * scaleX, y * scaleY);

    final Path shield = Path()
      ..moveTo(pt(12, 3).dx, pt(12, 3).dy)
      ..lineTo(pt(4, 7).dx, pt(4, 7).dy)
      ..lineTo(pt(4, 13).dx, pt(4, 13).dy)
      ..cubicTo(
        pt(4, 17.4183).dx,
        pt(4, 17.4183).dy,
        pt(7.58172, 21).dx,
        pt(7.58172, 21).dy,
        pt(12, 21).dx,
        pt(12, 21).dy,
      )
      ..cubicTo(
        pt(16.4183, 21).dx,
        pt(16.4183, 21).dy,
        pt(20, 17.4183).dx,
        pt(20, 17.4183).dy,
        pt(20, 13).dx,
        pt(20, 13).dy,
      )
      ..lineTo(pt(20, 7).dx, pt(20, 7).dy)
      ..close();

    final Path topBand = Path()
      ..moveTo(pt(4, 7).dx, pt(4, 7).dy)
      ..lineTo(pt(12, 11).dx, pt(12, 11).dy)
      ..lineTo(pt(20, 7).dx, pt(20, 7).dy);

    final Path centerLine = Path()
      ..moveTo(pt(12, 11).dx, pt(12, 11).dy)
      ..lineTo(pt(12, 21).dx, pt(12, 21).dy);

    canvas.drawPath(shield, paint);
    canvas.drawPath(topBand, paint);
    canvas.drawPath(centerLine, paint);
  }

  @override
  bool shouldRepaint(covariant _GiIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
