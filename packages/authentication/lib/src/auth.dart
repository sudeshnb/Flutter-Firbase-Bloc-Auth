import 'dart:async';

import 'package:auth/authentication.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'core/cache/cache.dart';
import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'core/models/functions.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthRepo {
  /// {@macro authentication_repository}
  ///
  AuthRepo({
    CacheClient? cache,
    auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final CacheClient _cache;
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to kIsWeb]
  ///
  @visibleForTesting
  bool isWeb = kIsWeb;

  ///
  ///
  ///
  ///
  String verificationId = '';

  /// User cache key.
  /// Should only be used for testing purposes.
  ///
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of User which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits User.empty if the user is not authenticated.
  ///
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to User.empty] if there is no cached user.
  ///
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  /// Creates a new user with the provided email and password].
  ///
  /// Throws a SignUpWithEmailAndPasswordFailure if an exception occurs.
  ///
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a LogInWithGoogleFailure if an exception occurs.
  ///
  Future<void> logInWithGoogle() async {
    try {
      late final auth.AuthCredential credential;
      if (isWeb) {
        final googleProvider = auth.GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  /// Starts the Sign In with Phone Number Flow.
  ///
  /// Throws a LogInWithPhoneNumberFailure if an exception occurs.
  ///
  FutureEither<bool> logInWithPhoneNumber({required String phone}) async {
    try {
      // late final firebase_auth.AuthCredential credential;

      if (isWeb) {
        ///
      } else {
        // final userCredential = await _firebaseAuth.signInWithPhoneNumber(phone);
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (auth.PhoneAuthCredential credential) async {
            // ANDROID ONLY!
            // Sign the user in (or link) with the auto-generated credential
            await _firebaseAuth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw LogInWithPhoneNumberFailure.fromCode(e.code);
          },
          codeSent: (String verificationId, int? resendToken) async {
            // Update the UI - wait for the user to enter the SMS code
            verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-resolution timed out...
          },
          // timeout: const Duration(seconds: 60),
        );
      }
      return Left(true);
      // await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      throw LogInWithPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      // throw const LogInWithPhoneNumberFailure();
      return Right('true');
    }
  }

  /// Starts the Sign In with Phone Number Flow verify otp code.
  ///
  /// Throws a LogInWithPhoneNumberFailure if an exception occurs.
  ///
  Future<void> verifyOtpCode({required String smsCode}) async {
    try {
      auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on auth.FirebaseAuthException catch (e) {
      throw LogInWithPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithPhoneNumberFailure();
    }
  }

  ///
  /// Signs in with the provided email and password.
  ///
  /// Throws a LogInWithEmailAndPasswordFailure if an exception occurs.
  ///
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// User.empty from the user Stream.
  ///
  /// Throws a LogOutFailure if an exception occurs.
  ///
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw LogOutFailure();
    }
  }

  /// Starts the Sign In with Apple Flow.
  ///
  /// Throws a LogInWithPhoneNumberFailure if an exception occurs.
  ///
  Future<void> logInWithWithApple() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      //
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      ///
      final oauthCredential = auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.

      await _firebaseAuth.signInWithCredential(oauthCredential);
    } on auth.FirebaseAuthException catch (e) {
      throw LogInWithPhoneNumberFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithPhoneNumberFailure();
    }
  }

  ///
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  ///
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of input in hex notation.
  ///
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  ///
}

extension on auth.User {
  ///
  /// Maps a firebase_auth.User into a User.
  ///
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
