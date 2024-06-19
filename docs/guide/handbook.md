# 使用手册

!> 森罗主要由Web管理后台slwx、网络空间测绘引擎senluo和万象漏洞扫描器cvs三部分组成，其中万象漏洞扫描器又分为扫描器cvs、反连服务器oob-server、漏洞规则调试工具ide。



##  :lemon: OOB架设 <!-- {docsify-ignore} -->
OOB全称**Out-of-Band**，有很多漏洞测试时并不直接回显任何信息，需要在公网架设一台OOB服务器来接收漏洞是否测试成功的结果。通常OOB服务器会接收漏洞测试所触发的dns、http、ldap、rmi、ftp等连接请求，并将结果返回给CVS扫描器。

1.首先将oob-server上传到公网可访问的服务器上

2.运行oob-server会自动生成一个名为cfg.yml的配置文件

```bash
./oob-server
```

3.修改配置文件：domain为dns服务器要解析的根域名，token为CVS扫描器连接OOB服务器的认证token，external_ip为该服务器的公网ip，ssl为CVS扫描器连接OOB服务器是否启用ssl连接，若为true则需要上传pem格式的tls证书server.crt和私钥server.key

```yaml
http_address: :80            //poc成功执行后请求的http地址，包括ip和端口。规则中对应格式：cvs.oob_url+"-"+poc_info
api_address: :33333          //cvs用来接收回连事件的http api地址，包括ip和端口
domain: example.com          //poc成功执行后请求的dns，规则中对应格式：poc_info+"-"+cvs.oob_dns
token: clt5j6r4uu422g7i8rrg  //cvs用来与接收回连事件的http api通信的认证token
external_ip: 3.3.3.3         //因国内很多服务器本身ip为内网ip地址，该ip对应该服务器的公网ip
ssl: false                   //CVS扫描器连接OOB服务器的http api通信是否启用ssl连接
log_level: info              //日志记录等级，fatal、error、info、debug
```

4.放开服务器的8081、53、33333端口访问，并将OOB服务器设置为NS解析服务器，如阿里云上的域名可以参考[链接](https://help.aliyun.com/zh/dws/user-guide/custom-dns-host)进行配置

```bash
pkill oob-server && ./oob-server &
```

5.进入森罗Web管理后台"系统设置->反连服务"，配置对应参数

##  :melon: 规则编写 <!-- {docsify-ignore} -->

命令行运行IDE

```sh
ide.exe
```

浏览器打开http://127.0.0.1:777/ 即可看到PoC开发环境，该IDE提供了PoC的编写、调试和保存等功能，并支持代码补全和智能提示，如下图所示：

<h3 align="center">
  <img src="https://slwx.uusec.com/_media/ide.png" class="sd"/>
  <br>
</h3>


上图右上角分别为运行、保存、刷新按钮，运行按钮用于调试PoC脚本，该脚本语法类似golang，图中 **cvs结构体** 在CVS扫描器中会自动根据target.json生成，无需实现，仅在调试时方便测试，自行声明。

此图展示的是CVE-2022-46169无回显漏洞测试脚本的编写过程，图中提供了 **debug函数** 用于打印调试信息，该函数兼容go语言中fmt.Printf的用法，结果显示于下方方框。对于有回显的漏洞可以直接通过 **return true** 返回来确认漏洞存在，对于需要返回一些信息的场景，如密码破解等，可以return一个字符串来保存结果，结果位于CVS扫描器生成的result.json中的poc_info字段中。

PoC脚本中的函数兼容Nuclei的帮助函数，详见[链接](https://docs.projectdiscovery.io/templates/reference/helper-functions) ，另外CVS也提供了网络请求相关lib库，详见[链接](https://github.com/Safe3/CVS/blob/main/library_CN.md) 。所以你可以较方便的将Nuclei的漏洞模板转换成CVS的PoC。更多PoC样例可参考CVS扫描器poc目录下的yaml文件。规则调试完毕后即可录入森罗攻击面管理平台。

