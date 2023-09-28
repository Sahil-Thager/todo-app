import 'package:flutter/material.dart';

abstract class CurrentState {}

class LoadingState extends CurrentState {}

class LoadedState extends CurrentState {}

class FailureState extends CurrentState {}

class IdelState extends CurrentState {}

abstract class BaseChangeNotifier extends ChangeNotifier {
  CurrentState state = IdelState();

  void loadingState() {
    state = LoadingState();
  }

  void loadedState() {
    state = LoadedState();
  }

  // (TODO: Not complete)
  void failureState(String failure) {
    state = FailureState();
  }
}
