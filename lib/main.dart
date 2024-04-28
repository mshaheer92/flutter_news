import 'package:clean_arch_flutter/config/theme/app_themes.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_bloc.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_event.dart';
import 'package:clean_arch_flutter/feature/home/presentation/pages/daily_news.dart';
import 'package:clean_arch_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../feature/home/presentation/bloc/home_data/local/local_home_state.dart';

Future<void> main() async {
  await initializeDependencies();
  runApp(BlocProvider<LocalHomeDataBloc>(
    create: (context) => sl()..add(const GetHomeData()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    sl.get<LocalHomeDataBloc>().add(const GetDailyNews());
  }

  bool _isUserLoggedIn = false; // Initial state for user login flag
  int _selectedIndex = 0; // Keeps track of the selected item
  final List<Widget> _screens = [
    const DailyNews(), // Your first screen widget
    SecondScreen(), // Your second screen widget
    ThirdScreen(), // Your third screen widget
    FourthScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalHomeDataBloc, LocalHomeDataState>(
      listener: (context, state) {
        if (state is LocalHomeDataLoadingDone) {
          final homeData = state.homeDataEntity;
          _isUserLoggedIn =
              homeData?.userId != null && homeData?.userName != null;
          setState(() {}); // Update state to trigger UI rebuild
        }
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              hoverColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(16),
              gap: 8,
              tabs: [
                const GButton(
                    icon: Icons.newspaper,
                    text: "News",
                    textColor: Colors.white),
                const GButton(
                    icon: Icons.search,
                    text: "Search",
                    textColor: Colors.white),
                if (_isUserLoggedIn)
                  const GButton(
                      icon: Icons.bookmark,
                      text: "Bookmarks",
                      textColor: Colors.white),
                const GButton(
                    icon: Icons.person,
                    text: "Profile",
                    textColor: Colors.white),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Second Screen'),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Third Screen'),
    );
  }
}

class FourthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Fourth Screen'),
    );
  }
}
