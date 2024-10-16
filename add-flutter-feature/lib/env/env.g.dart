// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env.dart';

// **************************************************************************
// EnviedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _Env {
  static const List<int> _enviedkeyapiKey = <int>[
    553986989,
    2053386181,
    1093803824,
    823083983,
    959849696,
    3192501931,
  ];

  static const List<int> _envieddataapiKey = <int>[
    553986972,
    2053386231,
    1093803779,
    823083918,
    959849602,
    3192501960,
  ];

  static final String apiKey = String.fromCharCodes(List<int>.generate(
    _envieddataapiKey.length,
    (int i) => i,
    growable: false,
  ).map((int i) => _envieddataapiKey[i] ^ _enviedkeyapiKey[i]));
}
