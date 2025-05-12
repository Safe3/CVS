# 常见问题
> 森罗 的发展离不开社区的每一位用户的支持，这里收集常见的使用问题 。



### :apple: 为什么我的森罗无法自动获得SSL证书？ <!-- {docsify-ignore} -->
?> 请将域名指向森罗所在服务器，并将/opt/slwx/config.json中的domain设置为你要绑定的域名，Web服务的监听端口port改为443，auto_ssl的值改为true，然后访问 https://yourdomain 后才会自动申请let's encrypt免费证书，申请成功后会存放于slwx/cert目录。

