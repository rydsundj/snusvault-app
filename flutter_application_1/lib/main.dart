import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'create.dart';
import 'home.dart';
import 'rate.dart';
import 'me.dart';
import 'users.dart';
import 'user_provider.dart';
import 'product_provider.dart';
import 'firebase_options.dart';
import 'user_profile.dart';
import 'theme_provider.dart';

//this defines all the routes in the app
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const InitialScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/rate',
      builder: (context, state) => const RateScreen(),
    ),
    GoRoute(
      path: '/me',
      builder: (context, state) => const MeScreen(),
    ),
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersScreen(),
    ),

    //this route uses the state.extra parameter to pass dynamic arguments like userID
    GoRoute(
      path: '/user_profile',
      builder: (context, state) {
        if (state.extra is! Map<String, String>) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Invalid or missing arguments.')),
          );
        }
        //passes both user ID and the visiting user ID.
        final args = state.extra as Map<String, String>;
        return UserProfileScreen(
          userId: args['userId']!,
          visitingUserId: args['visitingUserId']!,
        );
      },
    ),
  ],
);

Future<void> main() async {
  //ensures bindings and initliazed before any async code runs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //initializes and provides productprovider, userprovider, and themeprovider
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) =>
              ProductProvider()..fetchProducts()), // to load product data
      ChangeNotifierProvider(
          create: (context) => UserProvider()), // handles user related state
      ChangeNotifierProvider(
          create: (context) => ThemeProvider()), // handles theme state
    ],
    child: const MyApp(),
  ));
}

//MyApp acts as the root widget and applies global styles and routing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'SnusVault',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 0, 0)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.brown.shade100,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.tealAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.teal,
        ),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

//InitialScreen serves as the entry point for users, letting them choose between login or create
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme(); //toggle light/darkmode
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              './images/logo.jpg',
              height: 100,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              style: ElevatedButton.styleFrom(
                elevation: 20,
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/create'),
              style: ElevatedButton.styleFrom(
                elevation: 7,
                minimumSize: const Size(200, 60),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
