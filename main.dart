import 'package:flutter/material.dart';

const String studentName = 'GANTI_DENGAN_NAMA_ANDA';
const String studentId = 'GANTI_DENGAN_NIM_ANDA';

void main() => runApp(const CourseExplorerApp());

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ResponsiveShell(),
    );
  }
}

final courses = <Map<String, dynamic>>[
  {'title': 'Pemrograman Mobile', 'code': 'PM101', 'credits': 3, 'status': 'Aktif'},
  {'title': 'Basis Data', 'code': 'BD201', 'credits': 3, 'status': 'Aktif'},
  {'title': 'Pemrograman Web', 'code': 'PW202', 'credits': 3, 'status': 'Aktif'},
  {'title': 'Kecerdasan Buatan', 'code': 'AI301', 'credits': 3, 'status': 'Terdaftar'},
  {'title': 'Pengolahan Citra Digital', 'code': 'PC302', 'credits': 2, 'status': 'Aktif'},
];

class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    CoursesPage(),
    ProfilePage(),
  ];

  void selectPage(int index) => setState(() => selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded = constraints.maxWidth >= 840;

        if (!expanded) {
          return Scaffold(
            body: pages[selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: selectPage,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: 'Courses'),
                NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: selectPage,
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
                  NavigationRailDestination(icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school), label: Text('Courses')),
                  NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: pages[selectedIndex]),
            ],
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, $studentName', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('NIM: $studentId'),
            const SizedBox(height: 24),
            const Text('Jelajahi Course', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, c) {
                final columns = c.maxWidth < 600 ? 1 : c.maxWidth < 840 ? 2 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (_, i) => CourseCard(course: courses[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth < 600 ? 1 : constraints.maxWidth < 840 ? 2 : 3;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
            ),
            itemCount: courses.length,
            itemBuilder: (_, i) => CourseCard(course: courses[i]),
          );
        },
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  const CourseCard({super.key, required this.course});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavorite = false;

  Future<void> openDetail() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: widget.course),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course berhasil ditambahkan ke favorite')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: openDetail,
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.course['title']} dipilih')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book),
                  const Spacer(),
                  IconButton(
                    onPressed: () => setState(() => isFavorite = !isFavorite),
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  ),
                ],
              ),
              Text(widget.course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              const SizedBox(height: 6),
              Text('${widget.course['code']} • ${widget.course['credits']} SKS'),
              const Spacer(),
              Chip(label: Text(widget.course['status'])),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course['title'], style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text('Kode: ${course['code']}'),
            Text('Credits: ${course['credits']} SKS'),
            Text('Status: ${course['status']}'),
            const SizedBox(height: 20),
            Text('Mahasiswa: $studentName'),
            Text('NIM: $studentId'),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.favorite),
              label: const Text('Pilih / Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController nimController;
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: studentName);
    nimController = TextEditingController(text: studentId);
  }

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Feedback berhasil divalidasi dan siap disimpan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profil Mahasiswa', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nimController,
              decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().isEmpty ? 'NIM wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Komentar', border: OutlineInputBorder()),
              validator: (v) => v == null || v.trim().length < 5 ? 'Komentar minimal 5 karakter' : null,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.send),
              label: const Text('Kirim Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
