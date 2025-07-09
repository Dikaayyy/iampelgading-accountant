import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  PersistentTabController? _controller;

  PersistentTabController get controller {
    _controller ??= PersistentTabController(initialIndex: 0);
    return _controller!;
  }

  void navigateToTab(int index) {
    controller.jumpToTab(index);
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
  }
}
