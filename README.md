## Nginx 간단 설치 및 구축 Template

*Redhat 계열 Linux(64Bit) 설치 및 환경구성을 위한 Template 입니다*

#### Nginx 1.10.2 버전 검증

#### 설치 작업 전 확인사항

1. yum install gcc gc gcc-c++ make apr-util openssl openssl-devel zlib zlib-devel unzip perl
2. 엔진관리 계정(nginxadm) 생성 확인
3. openssl / GCC compiler 설치여부 확인
   - openssl과 openssl-devel (openssl lib로 openssl관련 헤더 파일정보가 있어 compile시 필요)
   - 예제>
     ```shell
     # rpm -qa | grep openssl
     openssl-0.9.8e-12.el5_4.1
     openssl-devel-0.9.8e-12.el5_4.1
     ```
   - GCC는 nginx 바이너리 설치파일 compile시 필수적임
   - 예제>
   ```shell
   # rpm -qa | grep gcc
   gcc-34-3.4.6-4
   libgcc-296-2.96-138
   ...등등...
   ```
4. 사용 포트 및 방화벽 확인
   - 이미 80포트를 어디선가 사용하고 있는가? 어떤 프로그램인가?
   ```shell
   # netstat -an | grep :80
   ```
   - 80포트가 물리 방화벽 또는 iptables를 사용한다면 열려있는가?
   ```shell
   # service iptables status
   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:80
   ```

### 설치 작업

1. 제약: Nginx 엔진 1에 포트를 분리한 다수 인스턴스 구성 방법임.
2. 로그 및 소스 경로 만들기: 서버 관리자계정(예: nginxadm) 으로 진행한다 (추후 로그 접근을 위함)
   - 서버 ID = '응용 프로그램 약어'_'포트' = 예) userserv_80
   - APP_LONG_NAME: = 각 응용 프로젝트 이름과 동일
   ```shell
   mkdir -p /logs001/nginxadm/nginx/access_log/서버ID
   mkdir -p /logs001/nginxadm/nginx/error_log
   mkdir -p /srch001/nginxadm/APP_LONG_NAME/htdocs
   ```
3. 설치 경로 만들기: 실제 서버 설치는 root 계정으로 진행한다
   ```shell
   # mkdir -p /engn001/nginxadm/nginx/installer
   cd /engn001/nginxadm/nginx/installer
   ```
4. nginx, pcre 다운로드
   ```shell
   ## CRONOLOG
   cd cronolog
   ./configure --prefix=/usr/local/cronolog 
   make && make install

   ## ZLIB
   wget http://zlib.net/zlib-1.2.8.tar.gz
   tar -zxvf zlib-1.2.8.tar.gz

   ## PCRE
   wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
   tar -zxvf pcre-8.39.tar.gz

   ## NGINX
   wget http://nginx.org/download/nginx-1.10.2.tar.gz
   tar -zxvf nginx-1.10.2.tar.gz
   ```

5. Nginx 설치
   ```shell
   cd nginx-1.10.2
   ./configure --prefix=/engn001/nginxadm/nginx/nginx-1.10.2 --user=nginxadm --group=nginxadm --with-pcre=/engn001/nginxadm/nginx/installer/pcre-8.39 --with-zlib=/engn001/nginxadm/nginx/installer/zlib-1.2.8
   make && make install
   ```

### 설정

1. Link
   ```shell
   cd /engn001/nginxadm/nginx/nginx-1.10.2
   ln -s /logs001/nginxadm/nginx logs
   ```

2. 환경설정 복사
   ```shell
   mkdir -p /engn001/nginxadm/nginx/nginx-1.10.2/conf/servers
   ```

   * 생성한 경로에 본 프로젝트의 'conf' 경로 복사
      - nginx.conf: Nginx 메인 설정 --> /engn001/nginxadm/nginx/nginx-1.10.2/conf 에 덮어쓰기
      - 서버ID.conf --> 파일명 수정 (실제 서버 ID로) --> /engn001/nginxadm/nginx/nginx-1.10.2/conf/servers 에 업로드
      - start.sh, stop.sh --> /engn001/nginxadm/nginx/nginx-1.10.2 에 업로드

3. 환경설정 수정
   * nginx.conf 설정 수정: 파일 내부 주석 참조
   * servers/실제서버ID.conf 설정 수정: 파일 내부 주석 참조

4. 소스 배포
   * Static 자원(html,css,javascript,image, ...)들을 아래 경로에 배포
      - /srch001/nginxadm/APP_LONG_NAME/htdocs

### 기동

* 본 프로젝트의 아래파일을 경로 복사
   - start.sh : 시작
   - stop.sh : 종료
