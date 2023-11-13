import 'package:bloc/bloc.dart';
import 'package:schedule_sgk/bloc/theme.bloc/theme_event.dart';
import 'package:schedule_sgk/bloc/theme.bloc/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  late SharedPreferences sharedPreferences;

  ThemeBloc() : super(ThemeInitial()) {
    on<ToggleTheme>((event, emit) async {
      await _mapToggleThemeToState(emit);
    });
    on<LoadTheme>((event, emit) async => {
      await _loadTheme(emit)
    });
  }

  Future<void> _mapToggleThemeToState(Emitter<ThemeState> emit) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      final bool currentTheme = sharedPreferences.getBool('theme') ?? false;
      final bool newTheme = !currentTheme;

      await sharedPreferences.setBool('theme', newTheme);

      if (!emit.isDone) {
        emit(ThemeUpdated(newTheme));
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _loadTheme(Emitter<ThemeState> emit) async {
    try {
      sharedPreferences = await SharedPreferences.getInstance();
      final bool currentTheme = sharedPreferences.getBool('theme') ?? false;

      if (!emit.isDone) {
        emit(ThemeLoaded(currentTheme));
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
