# Clean Architecture - TDD

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