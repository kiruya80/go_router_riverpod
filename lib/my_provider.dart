import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart'; // 코드 생성될 파일명

@riverpod
String helloWorld(HelloWorldRef ref) {
  return 'Hello world';
}

@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }
}