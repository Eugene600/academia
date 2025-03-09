import 'package:academia/database/database.dart';
import 'package:academia/utils/router/default_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:academia/features/features.dart';

extension GoRouterExtension on GoRouter {
  void clearStackAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacementNamed(location);
  }
}

class AcademiaRouter {
  static GoRouter get router => _router;
  static GlobalKey<NavigatorState> get globalNavigatorKey =>
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> get sectionNavigatorKey =>
      GlobalKey<NavigatorState>();

  static const String register = "register";
  static const String auth = "auth";
  static const String profile = "profile";
  static const String home = "home";
  static const String onboarding = "onboarding";
  static const String courseView = "course-view";
  static const String todo = "todo";
  static const String todoView = "todo-view";
  static const String featureComingSoon = "coming-soon";

  static final GoRouter _router = GoRouter(
    initialLocation: "/",
    navigatorKey: globalNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => LayoutScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              name: "dashboard",
              path: "/dashboard",
              builder: (context, state) {
                return Dashboard();
              },
            ),
          ]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: "courses",
                path: "/courses",
                builder: (context, state) => const CoursesPage(),
                routes: [
                  GoRoute(
                    name: courseView,
                    path: "/$courseView",
                    builder: (context, state) {
                      final CourseData course = state.extra as CourseData;
                      return CourseMobileViewPage(course: course);
                    },
                  ),
                ],
              ),
            ],
          ),
          //StatefulShellBranch(
          //  routes: [
          //    GoRoute(
          //      name: "essentials",
          //      path: "/essentials",
          //      builder: (context, state) => EssentialsPage(),
          //    ),
          //  ],
          //),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/profile",
              name: "profile",
              builder: (context, state) => const ProfilePage(),
            ),
          ])
        ],
      ),
      GoRoute(
        path: "/memberships",
        name: "memberships",
        builder: (context, state) => const MembershipPage(),
      ),
      GoRoute(
        path: "/",
        name: "/",
        builder: (context, state) => const DefaultRoute(),
      ),
      GoRoute(
        path: "/in-app-update",
        name: "in-app-update",
        builder: (context, state) => const InAppUpdatePage(),
      ),
      GoRoute(
        path: "/profile-update",
        name: "profile-update",
        builder: (context, state) => const ProfileEditingPage(),
      ),
      GoRoute(
        path: "/$onboarding",
        name: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: "/$auth",
        name: auth,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: "/$register",
        name: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        name: todoView,
        path: "/$todoView",
        builder: (context, state) {
          TodoData? todo = state.extra as TodoData?;
          return TodoViewPage(todoData: todo);
        },
      ),
    ],
  );
}
