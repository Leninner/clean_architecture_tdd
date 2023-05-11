import 'package:clean_architecture_tdd/core/error/exception.dart';
import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(as: #RemoteDataSourceMock),
  MockSpec<NumberTriviaLocalDataSource>(as: #LocalDataSourceMock),
  MockSpec<NetworkInfo>(as: #NetworkInfoMock),
])
import '__mocks__/number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late RemoteDataSourceMock mockRemoteDataSource;
  late LocalDataSourceMock mockLocalDataSource;
  late NetworkInfoMock mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = RemoteDataSourceMock();
    mockLocalDataSource = LocalDataSourceMock();
    mockNetworkInfo = NetworkInfoMock();

    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('When the device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('When the device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('NumberTriviaRepositoryImpl tests', () {
    group('getConcreteNumberTrivia', () {
      const tNumber = 1;
      const tNumberTriviaModel =
          NumberTriviaModel(number: tNumber, text: 'test trivia');
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test(
            'should return remote data when the call to remote data source is succesful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            'should cache te data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test(
            'should return a ServerException when the call to remote data source is unsuccesful',
            () async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());

          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test(
            'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            'should return a CacheException when the cache data is not present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });

    group('getRandomNumberTrivia tests', () {
      const tNumberTriviaModel =
          NumberTriviaModel(number: 123, text: 'test trivia');
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repositoryImpl.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test(
            'should return remote data when the call to remote data source is succesful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            'should cache te data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test(
            'should return a ServerException when the call to remote data source is unsuccesful',
            () async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          // act
          final result = await repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test(
            'should return last locally cached data when the cached data is present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(const Right(tNumberTrivia)));
        });

        test(
            'should return a CacheException when the cache data is not present',
            () async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());

          // act
          final result = await repositoryImpl.getRandomNumberTrivia();

          // assert
          verify(mockLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });
  });
}
