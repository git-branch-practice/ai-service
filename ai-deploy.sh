#!/bin/bash
set -e

echo "==== AI 서비스(FastAPI) 배포 시작 ===="

# 1. 기존 PM2 프로세스 정리
echo "기존 ai-service PM2 프로세스 종료 중..."
pm2 delete ai-service || true

# 2. Python 가상환경 생성
echo "Python 가상환경 생성 중..."
python3 -m venv venv

# 3. 가상환경 활성화
echo "Python 가상환경 활성화 중..."
source venv/bin/activate

# 4. 필요한 패키지 설치
echo "필요한 패키지 설치 중..."
pip install --upgrade pip
pip install fastapi uvicorn

# 5. PM2로 FastAPI 서버 실행
echo "PM2로 FastAPI 서버 실행 중..."
pm2 start venv/bin/uvicorn --name ai-service --interpreter python3 -- main:app --host 0.0.0.0 --port 5000

# 6. PM2 프로세스 저장 및 확인
pm2 save
pm2 status

echo "✅ AI 서비스 배포 완료"
