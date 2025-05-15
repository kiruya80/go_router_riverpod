# go_router_riverpod

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 안드로이드 스튜디오 버전
Android Studio Koala Feature Drop | 2024.1.2 Patch 1
Build #AI-241.19072.14.2412.12360217, built on September 13, 2024
Runtime version: 17.0.11+0-17.0.11b1207.24-11852314 aarch64
VM: OpenJDK 64-Bit Server VM by JetBrains s.r.o.
macOS 15.5
GC: G1 Young Generation, G1 Old Generation
Memory: 4096M
Cores: 10
Metal Rendering is ON
Registry:
ide.experimental.ui=true
Non-Bundled Plugins:
Dart (241.18968.26)
mobi.hsz.idea.gitignore (4.5.6)
io.flutter (85.2.1)

## flutter 버전
Flutter 3.29.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision ea121f8859 (5 weeks ago) • 2025-04-11 19:10:07 +0000
Engine • revision cf56914b32
Tools • Dart 3.7.2 • DevTools 2.42.3


https://jsonplaceholder.typicode.com

## 
flutter packages pub run build_runner build

lib/
├── core/
│   ├── constants/       # 앱 전체에서 사용되는 상수
│   ├── error/           # 앱 전체에서 사용되는 에러 처리 관련 코드
│   ├── extensions/      # Dart 확장 함수
│   ├── theme/           # 앱의 테마 (색상, 폰트 등)
│   └── utils/           # 앱 전반적인 유틸리티 함수 (특정 계층에 종속되지 않음)
├── data/
│   ├── data_sources/    # 데이터 제공처 (로컬, 원격)
│   │   ├── local/       # 로컬 데이터 소스 (캐시, 로컬 DB 등)
│   │   └── remote/      # 원격 데이터 소스 (API 통신)
│   │       ├── api/       # Retrofit API 인터페이스 (.g.dart 포함)
│   │       └── api_client.dart # Dio 인스턴스, 인터셉터 등 Retrofit 설정
│   ├── models/          # API 응답 및 요청에 사용될 데이터 모델 (DTOs)
│   ├── repositories/    # 도메인 계층의 Repository 인터페이스 구현체
│   │   ├── impl/        # Repository 인터페이스의 실제 구현체
│   │   │   └── auth_repository_impl.dart
│   │   │   └── user_repository_impl.dart
│   │   └── repositories.dart # Repository 인터페이스 구현체 export
│   └── repositories_impl.dart # (선택 사항) 모든 구현체 export
├── domain/
│   ├── entities/        # 순수한 비즈니스 엔티티
│   ├── repositories/    # 데이터 접근을 위한 추상 인터페이스 (예: auth_repository.dart, user_repository.dart)
│   ├── use_cases/       # 특정 비즈니스 로직 단위 (인터랙터)
│   └── ...
├── presentation/
│   ├── riverpod/        # Riverpod Provider 관리
│   │   ├── auth/
│   │   ├── home/
│   │   └── ...
│   ├── screens/         # 화면 위젯
│   ├── widgets/         # 재사용 가능한 UI 컴포넌트
├── routing/
│   └── ...              # Go Router 관련 설정 및 로직
├── services/            # 앱 전체에서 사용되는 독립적인 유틸리티성 로직
├── utils/               # 앱 전반적인 유틸리티 함수 (core/utils와 역할 구분)
├── config/              # 환경 설정 관련 파일
└── main.dart

**각 폴더 설명:**

* **`core/`**: 앱의 핵심적인 공통 요소를 담습니다.
* **`data/`**: 데이터 계층을 관리하며, 데이터 소스, 모델, Repository 구현체를 포함합니다.
* **`domain/`**: 비즈니스 로직과 핵심 엔티티를 포함합니다. Repository 인터페이스를 정의합니다.
* **`presentation/`**: UI와 상태 관리 (Riverpod)를 담당합니다.
* **`routing/`**: Go Router를 이용한 화면 이동 관련 코드를 포함합니다.
* **`services/`**: 앱 전체에서 사용되는 독립적인 서비스를 포함합니다.
* **`utils/`**: 앱 전반적으로 사용되는 유틸리티 함수를 포함합니다.
* **`config/`**: 환경 설정 파일을 포함합니다.
* **`main.dart`**: 앱의 시작점입니다.

**주요 사항:**

* **Riverpod**: `presentation/riverpod/` 폴더에서 상태를 관리합니다. 기능별 또는 화면별로 세분화하여 관리하는 것을 권장합니다.
* **Go Router**: `routing/` 폴더에서 앱의 화면 이동을 처리합니다.
* **Dio & Retrofit**: 네트워크 통신은 `data/data_sources/remote/` 폴더 아래에서 Dio를 사용하여 Retrofit API 클라이언트를 구현합니다. API 인터페이스 (`.g.dart`)와 설정 파일 (`api_client.dart`)을 분리했습니다.
* **Repository 패턴**: `domain/repositories/`에서 인터페이스를 정의하고, `data/repositories/impl/`에서 구현합니다. `data/repositories/repositories.dart`는 구현체를 export하여 의존성 주입을 용이하게 합니다.

**참고:**

* `common` 폴더는 필요에 따라 `core` 또는 `presentation/widgets`로 통합하거나, 명확한 역할을 가지도록 재정의할 수 있습니다.
* `firebase` 폴더는 필요에 따라 계층별로 더 세분화하여 관리할 수 있습니다.
* `utils` 폴더는 `core/utils`와 역할을 명확히 구분하여 사용합니다.