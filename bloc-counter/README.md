# bloc-counter

A simple counter app implemented using the BLoC pattern with `flutter_bloc`.

## Structure

- `lib/bloc/counter_event.dart` – defines `enum CounterEvent { increment, decrement }`.
- `lib/bloc/counter_bloc.dart` – `CounterBloc extends Bloc<CounterEvent, int>` and handles increment/decrement.
- `lib/widgets/home.dart` – `Home` widget showing the counter and + / - buttons using `BlocBuilder`.
- `lib/main.dart` – sets up `BlocProvider<CounterBloc>`, `SimpleBlocObserver`, and starts the app.

## Run

```bash
cd bloc-counter
flutter pub get
flutter run
```

Press `+` to increment and `-` to decrement the counter; all changes go through the BLoC.
