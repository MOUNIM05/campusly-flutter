import 'package:material_ui/material_ui.dart';

import '../widgets/custom_avatar.dart';
import '../widgets/page_intro.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AvatarPage')),
    body: ListView(
      padding: pagePadding(context),
      children: [
        const PageIntro(
          eyebrow: 'WIDGETS LAB / 02',
          title: 'A face for\nevery connection.',
          subtitle: 'CircleAvatar: initials, photographs, icons and graceful fallbacks.',
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
              spacing: 28,
              runSpacing: 26,
              alignment: WrapAlignment.spaceAround,
              children: [
                _example(
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFE3EAFE),
                    child: Text(
                      'SE',
                      style: TextStyle(
                        color: Color(0xFF4169F5),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  'Initials',
                  'Sara El Amrani → SE',
                ),
                _example(
                  const CustomAvatar(
                    name: 'Sara El Amrani',
                    photoUrl:
                        'https://randomuser.me/api/portraits/women/68.jpg',
                    radius: 32,
                  ),
                  'Network image',
                  'Falls back to initials',
                ),
                _example(
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFFDDF5EF),
                    child: Icon(
                      Icons.school_outlined,
                      color: Color(0xFF078F83),
                      semanticLabel: 'Student avatar',
                    ),
                  ),
                  'Icon',
                  'A simple identity',
                ),
                _example(
                  const CustomAvatar(
                    name: 'Yasmine Alaoui',
                    photoUrl: 'assets/portraits/student_1.jpg',
                    radius: 32,
                  ),
                  'Local asset',
                  'Always available offline',
                ),
              ],
            ),
          ),
        ),
        const SectionHeading(title: 'A colorful community'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Wrap(
              spacing: 22,
              runSpacing: 22,
              alignment: WrapAlignment.spaceAround,
              children: [
                for (var i = 0; i < 5; i++)
                  _example(
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Colors.primaries[i * 2].shade100,
                      child: Text(
                        initiales(
                          [
                            'Adam Bennani',
                            'Lina Idrissi',
                            'Nour Rami',
                            'Omar Fassi',
                            'Mehdi Mansouri',
                          ][i],
                        ),
                        style: TextStyle(
                          color: Colors.primaries[i * 2].shade900,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    ['Adam', 'Lina', 'Nour', 'Omar', 'Mehdi'][i],
                    'Colors.primaries[${i * 2}]',
                  ),
              ],
            ),
          ),
        ),
        const SectionHeading(title: 'A little detail goes a long way'),
        Card.filled(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white,
                  child: CustomAvatar(
                    name: 'Yasmine Alaoui',
                    photoUrl: 'assets/portraits/student_1.jpg',
                    radius: 40,
                    online: true,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A border. A presence.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Outer CircleAvatar: radius 44, white.\nInner CircleAvatar: radius 40, image.\nStack + Positioned: online badge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Images load inside ClipOval. Missing assets, invalid URLs and loading states display initials instead of a broken image.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
  Widget _example(Widget avatar, String title, String subtitle) => SizedBox(
    width: 126,
    child: Column(
      children: [
        avatar,
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9),
        ),
      ],
    ),
  );
}
