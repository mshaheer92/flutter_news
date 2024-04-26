import 'package:clean_arch_flutter/config/theme/app_themes.dart';
import 'package:clean_arch_flutter/feature/daily_news/domain/entities/article.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_bloc.dart';
import 'package:clean_arch_flutter/feature/home/presentation/bloc/home_data/local/local_home_event.dart';
import 'package:clean_arch_flutter/injection_container.dart';
import 'package:flutter/cupertino.dart';
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

class DailyNews extends StatelessWidget {
  const DailyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
        title: const Text('Daily News', style: TextStyle(color: Colors.black)));
  }

  _buildBody() {
    return BlocBuilder<LocalHomeDataBloc, LocalHomeDataState>(
        builder: (_, state) {
      if (state is RemoteArticlesLoading) {
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      }
      if (state is RemoteArticlesError) {
        return const Center(
          child: Icon(Icons.refresh),
        );
      }
      if (state is RemoteDailyNewsLoadingDone) {
        final articles = state.articles!;
        return ListView.separated(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return _buildNewsItem(article, context);
            },
            separatorBuilder: (context, index) => const Divider());
      }
      return const SizedBox();
    });
  }

  Widget _buildNewsItem(ArticleEntity article, BuildContext context) {
    double imageHeight = ((16.0 * 3) + (12 * 2) + 35);
    double imageWidth = MediaQuery.of(context).size.width / 3;
    String imageURL = '${article.urlToImage}';
    print('URL : $imageURL');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align top for image
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              width: imageWidth,
              height: imageHeight, // Adjust height as needed
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                // Placeholder image
                image: imageURL ?? '',
                // Handle null image URLs
                fit: BoxFit.cover, // Cover the container
              ),
            ),
          ),
          const SizedBox(width: 16.0), // Spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title ?? '',
                  maxLines: 3,
                  // Limit to 3 lines
                  overflow: TextOverflow.ellipsis,
                  // Handle overflow with ellipsis
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                // Spacing between title and description
                Text(
                  article.description ?? '',
                  maxLines: 2, // Limit to 2 lines
                  overflow:
                      TextOverflow.ellipsis, // Handle overflow with ellipsis
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Home Screen'),
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
