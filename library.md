# Library - "http"

```golang
resp := http.req("https://www.uusec.com", {method: "PUT"})
if is_error(resp) {
    debug("err: %s",resp.value)
    return
}
debug("%d %s %s",resp.status,resp.headers["Content-Type"],resp.body)
```
## Functions

- `req(url string,{method: string, headers: map, body: string, follow_redirects: bool, max_read_length: int, timeout: int }) => Http/error`: send http request and return Http or error,the second parameter is optional.

## Http

- `status => int`: http response status code.
- `headers => map`: http response headers.
- `body => string`: http response body.



# Library - "net"

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
## Functions

- `dial(addr string, {proto: string, tls: bool, idle_timeout: int, total_timeout: int}) => Net/error`: dial with tcp or udp protocol with or with no tls and return Net or error,the second parameter is optional.

## Net

- `close() => error`: close the socket.
- `read(out bytes) => int/error`: read data once from socket into parameter out and return read length,
  rendering it unusable in the future.
- `write(data bytes) => int/error`: write data once to the socket and return written length.
- `set_read_deadline(seconds int) => error`:  set read timeout for read function.
- `set_write_deadline(seconds int) => error`:  set write timeout for write function.
- `read_all(maxlen int) => bytes/error`: read data from socket until the max length is reached,this parameter is optional.
- `read_until(pattern string) => bytes/error`: read data from socket until the regex pattern is matched.

- `write_all(data bytes) => int/error`: write all data to the socket if possible and return written length.
