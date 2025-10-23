# 1. 빌드 스테이지: 애플리케이션을 빌드합니다.
FROM node:18-alpine AS builder

# 작업 디렉토리 설정
WORKDIR /app

# package.json 및 package-lock.json 복사
# 캐싱을 위해 종속성 파일만 먼저 복사
COPY package*.json ./

# 종속성 설치
RUN npm install

# 모든 소스 파일 복사
COPY . .

# 빌드 (Next.js 또는 React 앱의 경우 빌드 과정이 필요)
# jshweb 리포지토리가 단순 정적/Node.js 앱일 경우 이 라인은 필요 없을 수 있지만,
# 안전하게 Node.js 프로젝트의 일반적인 빌드 명령어를 사용합니다.
# 실제 프로젝트의 빌드 명령에 따라 수정될 수 있습니다.
# RUN npm run build 

# 2. 실행 스테이지: 가볍고 보안성이 높은 환경에서 앱을 실행합니다.
FROM node:18-alpine

# Node.js의 기본 웹 포트 설정
ENV PORT 80

# 작업 디렉토리 설정
WORKDIR /app

# 이전 빌드 스테이지에서 설치된 종속성 및 코드 복사
COPY --from=builder /app ./

# 컨테이너 시작 시 실행될 명령 설정
# 만약 build 스테이지에서 빌드했다면, 'npm start' 대신 빌드된 파일을 실행해야 합니다.
# 여기서는 일반적인 Node.js 시작 명령을 사용합니다.
CMD ["npm", "start"]
