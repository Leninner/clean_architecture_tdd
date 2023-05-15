import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('InputConverter tests', () {
    group('When the stringToUnsignedInteger method is called', () {
      test(
          'should return an integer when the string represents an unsigned integer',
          () {
        // arrange
        const str = '123';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, const Right(123));
      });

      test('should throw a Failure when the string is not an integer ', () {
        // arrange
        const str = 'abc';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      });

      test('should throw a Failure when the string is an negative number ', () {
        // arrange
        const str = '-78';

        // act
        final result = inputConverter.stringToUnsignedInteger(str);

        // assert
        expect(result, Left(InvalidInputFailure()));
      });
    });
  });
}
