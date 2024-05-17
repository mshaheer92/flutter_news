import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:clean_arch_flutter/feature/daily_news_detailed/presentation/pages/detailed_news.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_bloc.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_event.dart';
import 'package:clean_arch_flutter/feature/home/presentation/pages/daily_news.dart';
import 'package:clean_arch_flutter/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../feature/home/presentation/bloc/home_data/local/local_home_state.dart';

Future<void> main() async {
  await initializeDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await AdaptiveTheme.getThemeMode();
  runApp(BlocProvider<LocalHomeDataBloc>(
    create: (context) => sl()..add(const GetHomeData()),
    child: MyApp(savedThemeMode: themeMode),
  ));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'details',
            pageBuilder: (context, state) {
              final ArticleEntity article = state.extra as ArticleEntity;
              return CustomTransitionPage(
                  child: DetailedNewsPage(article: article),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    // Use a Tween to define the sliding effect
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0), // Start from the right
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  });
            }),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.white),
        dark: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.black),
        initial: savedThemeMode ?? AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp.router(
              title: 'My News',
              theme: theme,
              routerConfig: _router,
            ));
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
    BookmarksScreen(), // Your third screen widget
    ProfileScreen()
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
              onTabChange: (index) => setState(() => {
                    if (_isUserLoggedIn)
                      _selectedIndex = index
                    else
                      {
                        if (index == 2)
                          _selectedIndex = index + 1
                        else
                          _selectedIndex = index
                      }
                  }),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('This is the search screen'),
        ),
      ),
    );
  }
}

class BookmarksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'This is the Bookmarks screen',
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: AdaptiveTheme.of(context).mode.isDark,
              onChanged: (value) {
                if (value) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notification settings screen
            },
          ),
          ListTile(
            title: const Text('Language'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language settings screen
            },
          ),
        ],
      ),
    );
  }
}
