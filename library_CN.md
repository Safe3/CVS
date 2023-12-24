# 库 - "http"

```golang
resp := http.req("https://www.uusec.com", {method: "PUT"})
if is_error(resp) {
    debug("err: %s",resp.value)
    return
}
debug("%d %s %s",resp.status,resp.headers["Content-Type"],resp.body)
```
## 函数

- `req(url string,{method: string, headers: map, body: string, follow_redirects: bool, max_read_length: int, timeout: int }) => Http/error`: 发送http请求并返回 Http 对象或 error，第二个参数项是可选的。

## 返回Http对象

- `status => int`: http响应状态代码。
- `headers => map`: http响应标头。
- `body => string`: http响应主体。



# 库 - "net"

```golang
sock := net.dial("www.uusec.com:80")
if is_error(sock) {
    debug("err: %s",sock.value)
    return
}
n := sock.write_all("GET / HTTP/1.0\r\nHost: www.uusec.com\r\n\r\n")
if is_error(n) {
    debug("err: %s",n.value)
    return
}
data := sock.read_all()
debug("data: %s",string(data))
```
## 函数

- `dial(addr string, {proto: string, tls: bool, idle_timeout: int, total_timeout: int}) => Net/error`: 使用tcp或udp协议拨号，带或不带tls，并返回Net或error，第二个参数项是可选的。

## 返回Net对象

- `close() => error`: 关闭 socket.
- `read(out bytes) => int/error`: 将数据从套接字读取一次到参数out并返回读取长度
- `write(data bytes) => int/error`: 将数据写入套接字一次并返回写入的长度。
- `set_read_deadline(seconds int) => error`: 设置read函数的读取超时。
- `set_write_deadline(seconds int) => error`: 设置write函数的写入超时。
- `read_all(maxlen int) => bytes/error`: 从套接字读取数据，直到达到最大长度，此参数是可选的。
- `read_until(pattern string) => bytes/error`: 从套接字读取数据，直到正则表达式模式匹配。

- `write_all(data bytes) => int/error`: 如果可能，将所有数据写入套接字，并返回写入长度。
