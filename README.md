# Clean Architecture - TDD

## Dependency Injection

Package used: [get_it](https://pub.dev/packages/get_it)

A dependency injection is a technique where one object supplies the dependencies of another object. A dependency is an object that can be used (a service). An injection is the passing of a dependency to a dependent object (a client) that would use it.

### Best practices

- Use a dependency injection container to manage the dependencies.
- Register the dependencies in the container.
- Resolve the dependencies from the container.
- Use a singleton for the container.
- Use a factory to create the dependencies.
- Use a factory to create the container.

### Hands on

Create a file called `injection_container.dart` in the `lib` folder.

```dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl<type>(),
      inputConverter: sl<type>(),
      random: sl<type>(),
    ),
  );
}
```

## Mocks

- [Mockito documentation](https://pub.dev/packages/mockito)

### Best practices

If we can use a real object instead of a mock, we should use it. For example, if we can use a real `UserRepository` instead of a mock, we should use it.

If we can't use a real object, we should use a mock or a fake object. For example, if we can't use a real `UserRepository` because it depends on a database, we should use a mock or a fake object.

### Hands on

To make mocks with mockit we need to use `@GenerateNiceMocks` annotation in the test class.

```dart
@GenerateNiceMocks([MockSPec<UserRepository>()])
void main() {
  late MockUserRepository mockUserRepository;
  late Login login;

  setUp(() {
    mockUserRepository = MockUserRepository();
    login = Login(mockUserRepository);
  });

  test('should call login method from UserRepository', () async {
    await login('email', 'password');

    verify(mockUserRepository.login('email', 'password')).called(1);
  });
}
```

To generate the class

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```