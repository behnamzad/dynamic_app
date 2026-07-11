import 'package:auto_route/auto_route.dart';
import 'package:dynamic_app/feature/profile/presentation/profile_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class Tab1Screen extends StatelessWidget {
  const Tab1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
