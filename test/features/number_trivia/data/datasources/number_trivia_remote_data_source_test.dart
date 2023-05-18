import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exception.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';

import '../../../../fixtures/fixture_reader.dart';
import '__mocks__/number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Client>(as: #MockHttpClient),
  MockSpec<Request>(as: #MockHttpClientRequest),
  MockSpec<Response>(as: #MockHttpClientResponse),
])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttp200Success() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttp404Failure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => Response('something went wrong', 404));
  }

  group('NumberTriviaRemoteDataSource tests', () {
    group('When the getConcreteNumberTrivia method is called', () {
      const tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test('''should perform a GET request on an URL with number 
          being the endpoint and with application/json header''', () async {
        //arrange
        setUpMockHttp200Success();

        //act
        dataSource.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      });

      test('should return NumberTrivia when the response code is 200 (succss)',
          () async {
        //arrange
        setUpMockHttp200Success();

        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);

        // assert
        expect(result, equals(tNumberTriviaModel));
      });

      test('should throw an error when the statusCode is 404 or other',
          () async {
        //arrange
        setUpMockHttp404Failure();

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      });

      test('should throw an error when the fetch fails', () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenThrow(Exception());

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      });
    });

    group('When the getRandomNumberTrivia method is calles', () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test('''should perform a GET request on an URL with random
          being the endpoint and with application/json header''', () async {
        //arrange
        setUpMockHttp200Success();

        //act
        dataSource.getRandomNumberTrivia();

        //assert
        verify(mockHttpClient.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      });

      test('should return NumberTrivia when the response code is 200 (succss)',
          () async {
        //arrange
        setUpMockHttp200Success();

        // act
        final result = await dataSource.getRandomNumberTrivia();

        // assert
        expect(result, equals(tNumberTriviaModel));
      });

      test('should throw an error when the statusCode is 404 or other',
          () async {
        //arrange
        setUpMockHttp404Failure();

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      });
    });
  });
}
