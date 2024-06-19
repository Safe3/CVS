<h1 align="center">
  <br>
  <a href="https://www.uusec.com">CVS</a>
</h1>
<h4 align="center">万象漏洞扫描器</h4>

<p align="center">
<a href="https://github.com/Safe3/CVS/releases"><img src="https://img.shields.io/github/downloads/Safe3/CVS/total">
<a href="https://github.com/Safe3/CVS/graphs/contributors"><img src="https://img.shields.io/github/contributors-anon/Safe3/CVS">
<a href="https://github.com/Safe3/CVS/releases/"><img src="https://img.shields.io/github/release/Safe3/CVS">
<a href="https://github.com/Safe3/CVS/issues"><img src="https://img.shields.io/github/issues-raw/Safe3/CVS">
<a href="https://github.com/Safe3/CVS/discussions"><img src="https://img.shields.io/github/discussions/Safe3/CVS">
</p>
<p align="center">
  <a href="#特色">特色</a> •
  <a href="#使用">使用</a> •
  <a href="#为安全工程师">为安全工程师</a> •
  <a href="#感谢">感谢</a> •
  <a href="#联系">联系</a> •
  <a href="#授权">授权</a>
</p>




<p align="center">
  <a href="https://github.com/Safe3/CVS/blob/main/README.md">中文</a>
  <a href="https://github.com/Safe3/CVS/blob/main/README_EN.md">English</a>
</p>


---

与Nessus和Nuclei等许多产品一样，CVS用于扫描各种网络漏洞，但它更现代，具有免等待的OOB测试策略、高级漏洞PoC IDE和强大的VDSL（漏洞域特定语言）引擎，使您能够轻松快速地扫描几乎所有漏洞。它还具有轻量级、单一二进制文件、跨平台和无附加依赖性等特性。



## 特色

<h3 align="center">
  <img src="https://github.com/Safe3/CVS/blob/main/cvs.png" alt="CVS" width="700px">
  <br>
</h3>

 - 强大的PoC脚本语言 - **VDSL** (Domain Specific Language)
 - 先进易用的PoC开发和调试环境 - **CVS PoC IDE**
 - 更现代化，无需等待**OOB**服务器
 - 高速、高性能的漏洞扫描引擎
 - 与几乎所有Nuclei的**帮助函数**功能兼容，因此您可以轻松地将Nuclei模板转换为CVS PoC
 - 轻松提取森罗空间测绘引擎扫描的网络服务和指纹信息
 - 轻量级、单一二进制文件、跨平台且无其他依赖关系
 - 输出格式支持 - **JSON**



## 使用

CVS由三部分组成：**CVS扫描器**、**PoC IDE**和**OOB服务器**。CVS扫描器用于读取森罗空间测绘引擎生成的扫描目标信息，并加载PoC进行漏洞扫描。PoC IDE用于编写和调试漏洞脚本以及生成PoC文件。OOB服务器用于反向连接平台，如一些没有回显的漏洞，以确认漏洞的存在。VDSL语法可以参考链接[VDSL语法](https://github.com/Safe3/CVS/blob/main/VDSL_CN.md) 。


### 编写PoC

命令行运行IDE

```sh
ide.exe
```
浏览器打开http://127.0.0.1:777/ 即可看到PoC开发环境，该IDE提供了PoC的编写、调试和保存等功能，并支持代码补全和智能提示，如下图所示：

<h3 align="center">
  <img src="https://github.com/Safe3/CVS/blob/main/ide.png" alt="IDE" width="700px">
  <br>
</h3>

上图右上角分别为运行、保存、刷新按钮，运行按钮用于调试PoC脚本，该脚本语法类似golang，图中 **cvs结构体** 在CVS扫描器中会自动根据target.json生成，无需实现，仅在调试时方便测试，自行声明。

此图展示的是CVE-2022-46169无回显漏洞测试脚本的编写过程，图中提供了 **debug函数** 用于打印调试信息，该函数兼容go语言中fmt.Printf的用法，结果显示于下方方框。对于有回显的漏洞可以直接通过 **return true** 返回来确认漏洞存在，对于需要返回一些信息的场景，如密码破解等，可以return一个字符串来保存结果，结果位于CVS扫描器生成的result.json中的poc_info字段中。

PoC脚本中的函数兼容Nuclei的帮助函数，详见[链接](https://docs.projectdiscovery.io/templates/reference/helper-functions) ，另外CVS也提供了网络请求相关lib库，详见[链接](https://github.com/Safe3/CVS/blob/main/library_CN.md) 。所以你可以很方便的将Nuclei的漏洞模板转换成CVS的PoC。更多PoC样例可参考CVS扫描器poc目录下的yaml文件。

### 架设OOB服务器

OOB全称**Out-of-Band**，有很多漏洞测试时并不直接回显任何信息，需要在公网架设一台OOB服务器来接收漏洞是否测试成功的结果。通常OOB服务器会接收漏洞测试所触发的dns、http、ldap、rmi、ftp等连接请求，并将结果返回给CVS扫描器。

1.首先将oob-server上传到公网可访问的服务器上

2.运行oob-server会自动生成一个名为cfg.yml的配置文件

3.修改配置文件：domain为dns服务器要解析的根域名，token为CVS扫描器连接OOB服务器的认证token，external_ip为该服务器的公网ip，ssl为CVS扫描器连接OOB服务器是否启用ssl连接，若为true则需要上传pem格式的tls证书server.crt和私钥server.key

```yaml
http_address: :80            //poc成功执行后请求的http地址，包括ip和端口。规则中对应格式：cvs.oob_url+"-"+poc_info
api_address: :33333          //cvs用来接收回连事件的http api地址，包括ip和端口
domain: example.com          //poc成功执行后请求的dns，规则中对应格式：poc_info+"-"+cvs.oob_dns
token: clt6j6r4uu422g7i8rrg  //cvs用来与接收回连事件的http api通信的认证token
external_ip: 3.3.3.3         //因国内很多服务器本身ip为内网ip地址，该ip对应该服务器的公网ip
ssl: false                   //CVS扫描器连接OOB服务器的http api通信是否启用ssl连接
log_level: info              //日志记录等级，fatal、error、info、debug
```

4.放开服务器的80、53、33333端口访问，并将OOB服务器设置为NS解析服务器，如阿里云上的域名可以参考[链接](https://help.aliyun.com/zh/dws/user-guide/custom-dns-host)进行配置

### 开启CVS扫描器

CVS扫描器下面有poc、lib、db三个目录和一个配置文件cfg.yml。poc目录为PoC存放目录，子目录以服务协议命名。lib目录为用户自定义的VDSL库文件存放目录。db目录用于存放无回显漏洞详细信息的数据库文件。配置文件cfg.yml如下：

```yaml
oob_url: http://3.3.3.3
oob_dns: example.com
oob_server: "http://3.3.3.3:33333/events/"
oob_token: "clt6j6r4uu422g7i8rrg"
threads: 36
log_level: error
```

上面oob_url为OOB服务器的外网地址，用于http协议的反连。oob_dns为dns的根域名，用于dns协议的反连。oob_server为接收反连信息的长连接通信url。oob_token对应OOB服务器上的认证token。threads为CVS扫描器的并发线程数。

配置好上面配置后，将森罗网络空间测绘引擎生成的target.json拷过来，执行cvs即可开始扫描漏洞。

CVS命令行选项


```console
Usage of cvs:
  -i string
       扫描的目标输入文件路径（默认为森罗输出的“target.json”）
  -o string
       扫描结果输出文件路径（默认为“result.json”）
```



## 为安全工程师

CVS提供了大量功能，有助于安全工程师在其组织中自定义工作流程。通过强大的PoC IDE和VDSL脚本语言，安全工程师可以轻松地使用CVS创建他们的自定义漏洞检测平台。



## 感谢

感谢所有了不起的[社区贡献者发送PR](https://github.com/safe3/cvs/graphs/contributors)并不断更新此项目。请支持我们的朋友点个:heart:赞。

如果你有想法或某种改进，欢迎你贡献并参与该项目，随时发送你的PR。

<p align="center">
<a href="https://github.com/Safe3/CVS/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Safe3/CVS&max=500">
</a>
</p>

## 联系

<p><span style="unicode-bidi: bidi-override; direction: rtl;">moc.cesuu@troppus</span></p>



## 授权

CVS 仅用于个人免费使用，如要进行商业用途请联系我们获取商业授权。
