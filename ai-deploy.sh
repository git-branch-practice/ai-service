#!/bin/bash
set -e

echo "==== AI 서비스(FastAPI) 배포 시작 ===="

# 1. 기존 ai-service 디렉토리 삭제
if [ -d "ai-service" ]; then
  echo "기존 ai-service 삭제 중..."
  rm -rf ai-service
fi

# 2. GitHub에서 ai-service 클론
echo "ai-service 소스 클론 중..."
git clone -b develop https://github.com/git-branch-practice/ai-service.git

# 3. 클론한 디렉토리로 이동
cd ai-service

# 4. 기존 PM2 프로세스 정리
echo "기존 ai-service PM2 프로세스 종료 중..."
pm2 delete ai-service || true

# 5. Python 가상환경 생성
echo "Python 가상환경 생성 중..."
python3 -m venv venv

# 6. 가상환경 활성화
echo "Python 가상환경 활성화 중..."
source venv/bin/activate

# 7. 필요한 패키지 설치
echo "필요한 패키지 설치 중..."
pip install --upgrade pip
pip install fastapi uvicorn

# 8. PM2로 FastAPI 서버 실행
echo "PM2로 FastAPI 서버 실행 중..."
pm2 start venv/bin/uvicorn --name ai-service --interpreter python3 -- main:app --host 0.0.0.0 --port 5000

# 9. PM2 프로세스 저장
pm2 save

# 10. PM2 상태 보기
pm2 status

echo "✅ AI 서비스 배포 완료"
