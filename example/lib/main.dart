import 'package:flutter/material.dart';
import 'package:mesh_gradient_example/views/animated_mesh_gradient_view.dart';
import 'package:mesh_gradient_example/views/mesh_gradient_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mesh_gradient showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Text("1"),
              label: 'MeshGradient',
            ),
            BottomNavigationBarItem(
              icon: Text("2"),
              label: 'AnimatedMeshGradient',
            ),
          ],
        ),
        body: _currentIndex == 0
            ? const MeshGradientView()
            : const AnimatedMeshGradientView(),
      ),
    );
  }
}
