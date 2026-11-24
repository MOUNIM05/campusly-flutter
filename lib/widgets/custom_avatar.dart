import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

/// First letters of the first two words: Sara El Amrani -> SE.
String initiales(String nomComplet) {
  final words = nomComplet
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty);
  return words.take(2).map((w) => w.characters.first).join().toUpperCase();
}

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 24,
    this.online = false,
    this.color = AppColors.blue,
  });
  final String name;
  final String? photoUrl;
  final double radius;
  final bool online;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Text(
        initiales(name).isEmpty ? '?' : initiales(name),
        style: TextStyle(
          fontSize: radius * .62,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
    final photo = photoUrl;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: .13),
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: photo == null || photo.trim().isEmpty
              ? fallback
              : photo.startsWith('assets/')
              ? Image.asset(
                  photo,
                  fit: BoxFit.cover,
                  frameBuilder: (_, child, frame, loaded) =>
                      frame == null ? fallback : child,
                  errorBuilder: (_, error, stack) => fallback,
                )
              : Image.network(
                  photo,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stack) => fallback,
                  loadingBuilder: (_, child, progress) =>
                      progress == null ? child : fallback,
                ),
        ),
      ),
    );
    return Semantics(
      label: 'Profile of $name',
      image: true,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (online)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.turquoise,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
