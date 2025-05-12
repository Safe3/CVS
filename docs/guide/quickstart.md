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

**一键安装：**

```bash
sudo bash -c "$(curl -fsSL https://slwx.uusec.com/installer_cn.sh)"
```



**快速入门：**

1.访问http://ip:10203 ，默认登录用户名"admin"，密码"#Passw0rd" 。

2.进入任务管理菜单，新建网络空间测绘任务，等待任务结束后即可在资产管理界面看到所有测绘到的资产信息。

3.进入任务管理菜单，新建Nuclei漏洞扫描任务，等待任务结束后即可在漏洞管理界面看到所有扫描到的漏洞信息。



**产品卸载：**

```bash
sudo systemctl stop slwx && sudo /opt/slwx/slwx -s uninstall && sudo rm -rf /opt/slwx
```

