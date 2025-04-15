# 📱 Stock Game Client (Flutter)

Flutter로 제작한 주식 시뮬레이션 게임 앱의 클라이언트입니다.  
NestJS 백엔드 서버와 연동하여 사용자 자산, 주식 매수/매도 등의 기능을 제공합니다.

---

## ✅ 주요 기능

- 대시보드 화면
  - 보유 현금 표시
  - 보유 주식 리스트
  - 거래 가능한 종목 목록 표시
- 서버 연동 (`/dashboard` API)
  - NestJS 백엔드에서 데이터 받아오기
- 상태 관리: GetX
- 화면 구성: Obx + ListView 기반의 유동적 UI

---

## 📦 사용 기술

- Flutter 3.x
- GetX (상태관리)
- HTTP 통신 (`http` 패키지)
- UUID + SharedPreferences (간단한 사용자 식별용)

---

## 🚀 실행 방법

```bash
flutter pub get
flutter run
