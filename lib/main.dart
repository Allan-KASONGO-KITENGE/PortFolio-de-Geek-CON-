import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Portfolio',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String profileImage =
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&q=80';

  final List<Map<String, String>> projects = const [
    {
      'title': 'Projet 1',
      'description': 'Une courte description du projet 1.',
      'url': 'https://example.com'
    },
    {
      'title': 'Projet 2',
      'description': 'Une courte description du projet 2.',
      'url': 'https://example.com'
    },
    {
      'title': 'Projet 3',
      'description': 'Une courte description du projet 3.',
      'url': 'https://example.com'
    }
  ];

  final List<String> services = const [
    'BUREAUTIQUE',
    'DESIGN',
    'DEVELOPPEMENT (Web, mobile)'
  ];

  Future<void> _launchUrl(String raw) async {
    final uri = Uri.parse(raw);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $raw';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Portfolio')),
      drawer: _buildDrawer(context),
      body: LayoutBuilder(builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 800;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: isWide ? _buildWide(context) : _buildNarrow(context),
        );
      }),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 28),
                SizedBox(height: 12),
                Text('Votre Nom', style: TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('À propos'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Projets'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Contact'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWide(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(context),
              const SizedBox(height: 20),
              _skillsCard(),
              const SizedBox(height: 20),
              _servicesCard(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _projectsSection(),
              const SizedBox(height: 20),
              _contactCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _profileCard(context),
        const SizedBox(height: 20),
        _skillsCard(),
        const SizedBox(height: 20),
        _servicesCard(),
        const SizedBox(height: 20),
        _projectsSection(),
        const SizedBox(height: 20),
        _contactCard(),
      ],
    );
  }

  Widget _profileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(radius: 48, backgroundImage: NetworkImage(profileImage)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Votre Nom', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Développeur Flutter • UI/UX • Mobile & Web')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _skillsCard() {
    final skills = ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'Git'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Compétences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: skills.map((s) => Chip(label: Text(s))).toList())
        ]),
      ),
    );
  }

  Widget _servicesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('SERVICES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: services
                .asMap()
                .entries
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 12, child: Text('${e.key + 1}')),
                          const SizedBox(width: 12),
                          Expanded(child: Text(e.value)),
                        ],
                      ),
                    ))
                .toList(),
          )
        ]),
      ),
    );
  }

  Widget _projectsSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Projets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 1,
        childAspectRatio: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: projects.map((p) => _projectCard(p)).toList(),
      )
    ]);
  }

  Widget _projectCard(Map<String, String> project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(project['description'] ?? ''),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _launchUrl(project['url'] ?? ''),
            child: const Text('Voir'),
          )
        ]),
      ),
    );
  }

  Widget _contactCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Contact', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.email),
            const SizedBox(width: 8),
            GestureDetector(onTap: () => _launchUrl('mailto:you@example.com'), child: const Text('you@example.com'))
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.link),
            const SizedBox(width: 8),
            GestureDetector(onTap: () => _launchUrl('https://github.com/yourname'), child: const Text('github.com/yourname'))
          ])
        ]),
      ),
    );
  }
}
