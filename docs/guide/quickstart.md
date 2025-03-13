# 快速开始
森罗支持sqlite或mysql数据存贮，适合轻量级和重度环境使用，给你带来极致体验 。



##  :hotsprings: 配置要求 <!-- {docsify-ignore} -->
?> 森罗对配置要求极低，详细如下：

  ```
  - 处理器：64位 1千兆赫(GHz)或更快
  - 内存：不小于1G
  - 磁盘空间：不小于8G
  - 系统：Linux
  - CPU架构：AMD64或ARM
  ```



## :rocket: 安装使用 <!-- {docsify-ignore} -->
?> 森罗安装及其简便，通常在几分钟内即可安装完毕，具体耗时视网络下载情况而定。

下载并解压安装包：

```bash
sudo $( command -v yum || command -v apt-get ) install -y ca-certificates
curl https://download.uusec.com/slwx.tgz -o slwx.tgz && sudo tar -zxf slwx.tgz && rm -f ./slwx.tgz
```

后台运行：

```bash
sudo nohup slwx/slwx >/dev/null 2>&1 &
```

配置文件slwx/config.json说明： 
```json
{
 "ip": "0.0.0.0",                               //管理端绑定的ip
 "port": "80",                                  //管理端绑定的端口
 "domain":"",                                   //管理端绑定的域名
 "auto_ssl": false,                             //是否开启自动获取免费ssl证书，确保此时端口为443
 "sql_driver": "sqlite",                        //数据库选项，值sqlite或mysql
 "dsn": "/root/slwx/data.db",                   //sqlite数据库文件路径或mysql数据库dsn连接信息
 "jwt_key": "wLTI1GG5vPb6R3nE5FLcmQGzg4afzQsN", //网站jwt认证密钥
 "log_level": "error"                           //日志记录等级，fatal、error、info、debug
}
```

使配置生效： 
```bash
slwx/slwx -reload
```

?>登录管理后台：

1.将域名dns指向森罗服务器ip。

2.访问http://yourdomain ，默认登录用户名admin，密码Passw0rd! 。

3.进入任务管理菜单，新建网络空间测绘任务，等待任务结束后即可在资产管理界面看到所有测绘到的资产信息。

4.进入任务管理菜单，新建Nuclei漏洞扫描任务，等待任务结束后即可在漏洞管理界面看到所有扫描到的漏洞信息。

