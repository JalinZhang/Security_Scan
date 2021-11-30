# SecurityScan
> 作用：自动组件安全扫描

V1.0 功能介绍：

1. 提供一键安全扫描，覆盖绝大多数组件

详情如下：
​

## DEMO
![动画.gif](https://cdn.nlark.com/yuque/0/2021/gif/399728/1627028563572-4d7d88b9-38ea-469d-834e-1a9ba03b8c89.gif#clientId=u79093dba-e216-4&from=ui&id=ud20a75a2&margin=%5Bobject%20Object%5D&name=%E5%8A%A8%E7%94%BB.gif&originHeight=636&originWidth=1569&originalType=binary&ratio=1&size=389241&status=done&style=none&taskId=ud31dc139-e969-4781-bed7-24d5abe3b2b)

1. 查看帮助
```bash
(venv) [/tmp/Security_Scan]# python SecurityScan.py -h

 _____                      _ _           _____
/  ___|                    (_) |         /  ___|
\ `--.  ___  ___ _   _ _ __ _| |_ _   _  \ `--.  __ _  ___ _ __
 `--. \/ _ \/ __| | | | '__| | __| | | |  `--. \/ _` |/ __| '_ \
/\__/ /  __/ (__| |_| | |  | | |_| |_| | /\__/ / (_| | (__| | | |
\____/ \___|\___|\__,_|_|  |_|\__|\__, | \____/ \__,_|\___|_| |_|
                                   __/ |
                                  |___/
                                    ——————   By JalinZhang | v1.0

Welcome To SecurityScan Tool !!!
Readme：https://sipc.yuque.com/sipc/security/dx8s5t

usage: SecurityScan.py [-h] [-i IP] [-p PORT] [-u USER] [-d PASSWORD] [-f FILE]

optional arguments:
  -h, --help   show this help message and exit

Scanner:
  -i IP        target host ip address
  -p PORT      target address ssh port
  -u USER      target host ssh user
  -d PASSWORD  target user ssh password
  -f FILE      target hosts list file name

```
2. 指定IP扫描（ip/端口/用户名/密码）
```bash
(venv) root@jaln[/tmp/Security_Scan]# python SecurityScan.py -i 172.16.17.126 -p 22 -u root -d abc@123A
           ___                       _
          / _ \__   _____ _ ____   _(_) _____      __
         | | | \ \ / / _ \ '__\ \ / / |/ _ \ \ /\ / /
         | |_| |\ V /  __/ |   \ V /| |  __/\ V  V /
          \___/  \_/ \___|_|    \_/ |_|\___| \_/\_/

——————————————————————————————————————————————————————————————————
    Layer                      Profile
-----------------------------------------------------------------
  Applicaiton     MySQL  、 PostgreSQL  、Apathe Tomcat、 Nginx
-----------------------------------------------------------------
  Components          SSH  、   SSL   、  Docker   、 K8S
-----------------------------------------------------------------
   OS                      Linux_compalnce
 ——————————————————————————————————————————————————————————————————


Enter Profile You Want to Scan: ssh
```

3. 查看扫描结果
```bash
cd /tmp/scan_result/
(venv)[/tmp/scan_result]# ll
drwxr-xr-x  html
drwxr-xr-x  json
```
![image.png](https://cdn.nlark.com/yuque/0/2021/png/399728/1627027180131-09598cdc-26a6-4688-9f14-4b1861860a15.png#clientId=u79093dba-e216-4&from=paste&height=503&id=ued608e0d&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1006&originWidth=2255&originalType=binary&ratio=1&size=166709&status=done&style=none&taskId=u4a55501d-c46e-47bf-9337-11db5558cdc&width=1127.5)


## 环境配置


### 1. 配置inspec
#### Option1：Package installer
```bash
#curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec
```
#### Option 2 (Terminal install)

1. 安装Ruby
```bash

When installing from source, gem dependencies may require ruby build tools to be installed.
#For CentOS/RedHat/Fedora:
$ yum -y install ruby ruby-devel make gcc gcc-c++
#For Debian/Ubuntu:
$ apt-get -y install ruby ruby-dev gcc g++ make

```

2. 安装inspec
```bash
$ gem install inspec
```
### 2. 配置python
```bash
wget https://www.python.org/ftp/python/3.8.6/Python-3.8.6.tgz
tar -xvJf  Python-3.8.6.tgz
mv Python-3.8.6 /usr/local/python3
cd /usr/local/python3
./configure --prefix=/usr/local/python3 
make && make install
ln -s /usr/local/python3/bin/python3 /us/bin/python3
ln -s /usr/local/python3/bin/pip3 /us/bin/pip3
pip3 install prompt_toolkit
```
# 
# Heimdall2.0
> 作用：inspec扫描报告展示

Heimdall Server VS Heimdall Light online功能介绍：
​

​

## DEMO
![Heimdall_demo.gif](https://cdn.nlark.com/yuque/0/2021/gif/399728/1627010861862-189e8b26-ea6e-43a5-8ce5-378d0705e2a3.gif#clientId=u8d1779ec-fd70-4&from=ui&id=u6ad83432&margin=%5Bobject%20Object%5D&name=Heimdall_demo.gif&originHeight=563&originWidth=1080&originalType=binary&ratio=1&size=16248922&status=done&style=none&taskId=uee97c802-3aa1-45de-b2e3-a3c057fae10)
MITRE Heimdall Viewer 有两个版本——完整的 Heimdall Enterprise Server 和 Heimdall-Lite 版本。两者共享相同的前端，但都是为了满足不同的需求和用例而生产的。
​

## Heimdall Light
> 适用于单节点少量报告查看和检测，只支持手动导入

[https://heimdall-lite.mitre.org/](https://heimdall-lite.mitre.org/)


## Heimdall server
> 适用于多台主机报告查看和检测，可通过扫描工具导入，也可手动导入报告

鉴于 Heimdall server至少需要一个数据库服务，我们使用 Docker 和 Docker Compose 来提供简单的部署
​

### 设置 Docker 容器

1. 安装 Docker
1. 下载Heimdall压缩包至本地并解压[heimdall2-master.zip](https://sipc.yuque.com/attachments/yuque/0/2021/zip/399728/1627014345774-76f89a95-fd15-4e37-8f86-b17dcc748076.zip?_lake_card=%7B%22src%22%3A%22https%3A%2F%2Fsipc.yuque.com%2Fattachments%2Fyuque%2F0%2F2021%2Fzip%2F399728%2F1627014345774-76f89a95-fd15-4e37-8f86-b17dcc748076.zip%22%2C%22name%22%3A%22heimdall2-master.zip%22%2C%22size%22%3A24128017%2C%22type%22%3A%22application%2Fx-zip-compressed%22%2C%22ext%22%3A%22zip%22%2C%22status%22%3A%22done%22%2C%22taskId%22%3A%22u4c16c4da-0c74-4b63-8222-024d6ffd988%22%2C%22taskType%22%3A%22upload%22%2C%22id%22%3A%22u8cada9d9%22%2C%22card%22%3A%22file%22%7D)
1. 导航到docker-compose.yml所在的基本文件夹/heimdall2-master
```bash
[/root]# cd heimdall2-master/
[/root/heimdall2-master]# ll | grep docker-compose.yml
docker-compose.yml
```

4. 默认情况下，Heimdall 将生成自签名证书，有效期为 7 天。将您的证书文件分别放入/heimdall2-master/nginx/certs/文件下，文件名分别为ssl_certificate.crt和ssl_certificate_key.key。
```bash
[/root/heimdall2-master/nginx/certs]# 
ssl_certificate.crt
ssl_certificate_key.key
```

5. 在 Heimdall 源目录/heimdall2-master/的终端窗口中运行以下命令
```bash
[/root/heimdall2-master]# ./setup-docker-secrets.sh  #如果你想进一步配置你的 Heimdall 实例，编辑运行上一行后生成的 .env 文件
[/root/heimdall2-master]# docker  -compose up -d
```
> 有关 .env 文件的更多信息，请访问[环境变量配置。](https://github.com/mitre/heimdall2/wiki/Environment-Variables-Configuration)
> 默认端口映射为"3000:3000"，若需要修改端口映射，在docker-compose.yml中修改

6. 导航到 [http://ipaddress:3000](http://127.0.0.1:3000/)





