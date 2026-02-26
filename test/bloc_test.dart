import 'package:flutter_test/flutter_test.dart';
import 'package:kappa_framework/kappa_framework.dart';
import 'package:bloc_test/bloc_test.dart';

class TestBloc extends KappaBloc<String> {
  TestBloc(super.kappaState);

  void fetch(String input) {
    emit(KappaState.loading());
    if (input == 'error') {
      emit(KappaState.error(const ServerFailure('Failed')));
    } else {
      emit(KappaState.success(input));
    }
  }
}

void main() {
  group('KappaBloc (Cubit) Tests', () {
    blocTest<TestBloc, KappaState<String>>(
      'nên emit [loading, success] khi fetch thành công',
      build: () => TestBloc(),
      act: (bloc) => bloc.fetch('hello'),
      expect: () => [
        isA<KappaState<String>>().having(
          (s) => s.status,
          'status',
          KappaStatus.loading,
        ),
        isA<KappaState<String>>().having(
          (s) => s.status,
          'status',
          KappaStatus.success,
        ),
      ],
    );

    blocTest<TestBloc, KappaState<String>>(
      'nên emit [loading, error] khi fetch thất bại',
      build: () => TestBloc(),
      act: (bloc) => bloc.fetch('error'),
      expect: () => [
        isA<KappaState<String>>().having(
          (s) => s.status,
          'status',
          KappaStatus.loading,
        ),
        isA<KappaState<String>>().having(
          (s) => s.status,
          'status',
          KappaStatus.error,
        ),
      ],
    );
  });
}
