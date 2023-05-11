import 'package:clean_architecture_tdd/core/platform/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '__mocks__/network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () async {
    test(
      'should forward the call to Connectivity.checkConnectivity method',
      () async {
        // arrange
        const tHasConnection = ConnectivityResult.wifi;
        final tHasConnectionFuture = Future.value(tHasConnection);

        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) => tHasConnectionFuture);

        // act
        final result = await networkInfoImpl.isConnected;

        // assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, true);
      },
    );
  });
}
