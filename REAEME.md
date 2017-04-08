## Nginx ���� ��ġ �� ���� Template

#### ��ġ �۾� �� Ȯ�λ���

1. yum install gcc gc gcc-c++ make apr-util openssl openssl-devel zlib zlib-devel unzip perl
2. �������� ����(nginxadm) ���� Ȯ��
3. openssl / GCC compiler ��ġ���� Ȯ��
   - openssl�� openssl-devel (openssl lib�� openssl���� ��� ���������� �־� compile�� �ʿ�)
   - ����>
     ```shell
     # rpm -qa | grep openssl
     openssl-0.9.8e-12.el5_4.1
     openssl-devel-0.9.8e-12.el5_4.1
     ```
   - GCC�� nginx ���̳ʸ� ��ġ���� compile�� �ʼ�����
   - ����>
   ```shell
   # rpm -qa | grep gcc
   gcc-34-3.4.6-4
   libgcc-296-2.96-138
   ...���...
   ```
4. ��� ��Ʈ �� ��ȭ�� Ȯ��
   - �̹� 80��Ʈ�� ��𼱰� ����ϰ� �ִ°�? � ���α׷��ΰ�?
   ```shell
   # netstat -an | grep :80
   ```
   - 80��Ʈ�� ���� ��ȭ�� �Ǵ� iptables�� ����Ѵٸ� �����ִ°�?
   ```shell
   # service iptables status
   ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state NEW tcp dpt:80
   ```

### ��ġ �۾�

1. ����: Nginx ���� 1�� ��Ʈ�� �и��� �ټ� �ν��Ͻ� ���� �����.
2. �α� �� �ҽ� ��� �����: ���� �����ڰ���(nginxadm) ���� �����Ѵ� (���� �α� ������ ����)
   - ���� ID = '���� ���α׷� ���'_'��Ʈ' = ��) userserv_80
   - APP_LONG_NAME: = �� Java ������Ʈ �̸��� ����
   ```shell
   mkdir -p /logs001/nginxadm/nginx/access_log/����ID
   mkdir -p /logs001/nginxadm/nginx/error_log
   mkdir -p /srch001/nginxadm/APP_LONG_NAME/htdocs
   ```
3. ��ġ ��� �����: ���� ���� ��ġ�� root �������� �����Ѵ�
   ```shell
   # mkdir -p /engn001/nginxadm/nginx/installer
   cd /engn001/nginxadm/nginx/installer
   ```
4. nginx, pcre �ٿ�ε�
   ```shell
   ```
CRONOLOG
cd cronolog
./configure --prefix=/usr/local/cronolog 
make && make install

ZLIB
wget http://zlib.net/zlib-1.2.8.tar.gz
tar -zxvf zlib-1.2.8.tar.gz

PCRE
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz
tar -zxvf pcre-8.39.tar.gz

NGINX
wget http://nginx.org/download/nginx-1.10.2.tar.gz
tar -zxvf nginx-1.10.2.tar.gz

5. Nginx ��ġ
cd nginx-1.10.2
./configure --prefix=/engn001/nginxadm/nginx/nginx-1.10.2 --user=nginxadm --group=nginxadm --with-pcre=/engn001/nginxadm/nginx/installer/pcre-8.39 --with-zlib=/engn001/nginxadm/nginx/installer/zlib-1.2.8
make && make install

< ���� >
1. Link
cd /engn001/nginxadm/nginx/nginx-1.10.2
ln -s /logs001/nginxadm/nginx logs

2. ȯ�漳�� ���ε�
mkdir -p /engn001/nginxadm/nginx/nginx-1.10.2/conf/servers
÷���� ���� ���ε�
. nginx.conf: Nginx ���� ���� --> /engn001/nginxadm/nginx/nginx-1.10.2/conf �� �����
. ����ID.conf --> ���ϸ� ���� (���� ���� ID��) --> /engn001/nginxadm/nginx/nginx-1.10.2/conf/servers �� ���ε�
. start.sh, stop.sh --> /engn001/nginxadm/nginx/nginx-1.10.2 �� ���ε�

3. ȯ�漳�� ����
. nginx.conf ���� ����: ���� ���� �ּ� ����
. servers/��������ID.conf ���� ����: ���� ���� �ּ� ����

4. �ҽ� ����
Static �ڿ�(html,css,javascript,image, ...)���� �Ʒ� ��ο� ����
: /srch001/nginxadm/APP_LONG_NAME/htdocs

< �⵿ >
start.sh : ����, stop.sh : ����