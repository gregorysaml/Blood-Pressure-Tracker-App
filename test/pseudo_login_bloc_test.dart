import 'package:bloc_test/bloc_test.dart';
import 'package:bloddpressuretrackerapp/bloc/login_bloc/bloc/pseudo_login_bloc.dart';
import 'package:bloddpressuretrackerapp/enums/pseudo_login_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PseudoLoginBloc', () {
    late PseudoLoginBloc pseudoLoginBloc;

    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
      pseudoLoginBloc = PseudoLoginBloc();
    });

    tearDown(() {
      pseudoLoginBloc.close();
    });

    test('initial state is PseudoLoginState with loggedOut status', () {
      expect(
        pseudoLoginBloc.state,
        equals(const PseudoLoginState(status: PseudoLoginStatusEnum.loggedOut)),
      );
    });

    group('PseudoSignInEvent', () {
      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggingIn, loggedIn] when sign in with correct credentials',
        build: () => pseudoLoginBloc,
        act: (bloc) => bloc.add(
          const PseudoSignInEvent(username: 'admin', password: 'admin'),
        ),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggingIn),
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedIn),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggingIn, loggedOut] when sign in with incorrect credentials',
        build: () => pseudoLoginBloc,
        act: (bloc) => bloc.add(
          const PseudoSignInEvent(username: 'wrong', password: 'wrong'),
        ),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggingIn),
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedOut),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggingIn, error] when sign in with empty password',
        build: () => pseudoLoginBloc,
        act: (bloc) => bloc.add(
          const PseudoSignInEvent(username: 'admin', password: ''),
        ),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggingIn),
          const PseudoLoginState(status: PseudoLoginStatusEnum.error),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggingIn, error] when sign in with both empty credentials',
        build: () => pseudoLoginBloc,
        act: (bloc) => bloc.add(
          const PseudoSignInEvent(username: '', password: ''),
        ),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggingIn),
          const PseudoLoginState(status: PseudoLoginStatusEnum.error),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'saves login status to SharedPreferences when login is successful',
        build: () => pseudoLoginBloc,
        act: (bloc) => bloc.add(
          const PseudoSignInEvent(username: 'admin', password: 'admin'),
        ),
        verify: (_) async {
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getBool('isLogged'), isTrue);
        },
      );
    });

    group('CheckLoginStatusEvent', () {
      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggedIn] when user is already logged in',
        build: () {
          SharedPreferences.setMockInitialValues({'isLogged': true});

          return PseudoLoginBloc();
        },
        act: (bloc) => bloc.add(const CheckLoginStatusEvent()),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedIn),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggedOut] when user is not logged in',
        build: () {
          SharedPreferences.setMockInitialValues({'isLogged': false});
          
          return PseudoLoginBloc();
        },
        act: (bloc) => bloc.add(const CheckLoginStatusEvent()),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedOut),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggedOut] when no login status is stored',
        build: () {
          SharedPreferences.setMockInitialValues({});

          return PseudoLoginBloc();
        },
        act: (bloc) => bloc.add(const CheckLoginStatusEvent()),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedOut),
        ],
      );
    });

    group('PseudoSignOutEvent', () {
      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'emits [loggingIn, loggedOut] when sign out',
        build: () {
          SharedPreferences.setMockInitialValues({'isLogged': true});

          return PseudoLoginBloc();
        },
        act: (bloc) => bloc.add(const PseudoSignOutEvent()),
        expect: () => [
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggingIn),
          const PseudoLoginState(status: PseudoLoginStatusEnum.loggedOut),
        ],
      );

      blocTest<PseudoLoginBloc, PseudoLoginState>(
        'removes login status from SharedPreferences when sign out',
        build: () {
          SharedPreferences.setMockInitialValues({'isLogged': true});

          return PseudoLoginBloc();
        },
        act: (bloc) => bloc.add(const PseudoSignOutEvent()),
        verify: (_) async {
          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getBool('isLogged'), isFalse);
        },
      );
    });
  });
}
