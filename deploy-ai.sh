#!/bin/bash
set -euo pipefail

echo "🚀 [START] AI 서비스(FastAPI) 배포 시작"

# === [0] 설정 ===
ROOT_DIR="$HOME/ai-service"
REPO_URL="https://github.com/git-branch-practice/ai-service.git"
BRANCH="develop"
PORT=5000
SERVICE_NAME="ai-service"

# === [1] 루트 디렉토리로 이동 ===
echo "📁 작업 디렉토리 이동: $ROOT_DIR"
cd "$HOME"

# === [3] 기존 소스 제거 ===
echo "🧹 기존 소스 제거"
rm -rf *

# === [4] Git에서 소스 클론 ===
echo "🔄 Git 클론: $REPO_URL (브랜치: $BRANCH)"
git clone -b "$BRANCH" "$REPO_URL" .

# === [5] 기존 PM2 프로세스 종료 ===
echo "🛑 기존 PM2 프로세스 종료: $SERVICE_NAME"
pm2 delete "$SERVICE_NAME" || true

# === [6] Python 가상환경 생성 ===
echo "🐍 Python 가상환경 생성"
python3 -m venv venv

# === [7] 가상환경 활성화 및 의존성 설치 ===
echo "📦 의존성 설치"
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt || pip install fastapi uvicorn

# === [8] PM2로 FastAPI 실행 ===
echo "🚦 PM2로 FastAPI 실행: $SERVICE_NAME"
pm2 start venv/bin/uvicorn \
  --name "$SERVICE_NAME" \
  --interpreter python3 \
  -- main:app \
  --host 0.0.0.0 \
  --port "$PORT"

# === [9] PM2 상태 저장 및 확인 ===
pm2 save
pm2 status

echo "✅ [DONE] AI 서비스 배포 완료: http://localhost:$PORT"