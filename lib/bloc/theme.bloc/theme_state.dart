import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeUpdated extends ThemeState {
  final bool newTheme;

  ThemeUpdated(this.newTheme);

  @override
  List<Object> get props => [newTheme];
}

class ThemeLoaded extends ThemeState {
  final bool newTheme;

  ThemeLoaded(this.newTheme);

  @override
  List<Object> get props => [newTheme];
}
