# 内置函数

## format

返回格式化的字符串。第一个参数必须是string对象。

```go
a := [1, 2, 3]
s := format("Foo: %v", a) // s == "Foo: [1, 2, 3]"
```

## len

如果给定的变量是数组、字符串、映射或对象，则返回元素的数量。

```go
v := [1, 2, 3]
l := len(v) // l == 3
```

## copy

创建给定变量的副本。`copy` 函数调用复制接口方法，该方法预期返回其所持值的深层副本。

```go
v1 := [1, 2, 3]
v2 := v1
v3 := copy(v1)
v1[1] = 0
print(v2[1]) // "0"; 'v1' and 'v2' referencing the same array
print(v3[1]) // "2"; 'v3' not affected by 'v1'
```

## append

将对象附加到数组（第一个参数）并返回一个新的数组对象。（类似于 Go 的 `append` 内置函数。）目前，此函数仅接受数组类型。

```go
v := [1]
v = append(v, 2, 3) // v == [1, 2, 3]
```

## delete

从映射类型中删除具有指定键的元素。第一个参数必须是映射类型，第二个参数必须为字符串类型。（就像Go的“delete”内置程序一样，除了键总是字符串）。如果成功，delete将返回“nil”值。

```go
v := {key: "value"}
delete(v, "key") // v == {}
```

```go
v := {key: "value"}
delete(v, "missing") // v == {"key": "value"}
```

```go
delete({}) // runtime error, second argument is missing
delete({}, 1) // runtime error, second argument must be a string type
```

## splice

删除和/或更改给定数组的内容并返回已删除的项作为新数组`拼接`，类似于JS  Array.prototype.splice。第一个参数必须是数组，并且
如果提供了第二个和第三个参数，它们必须是整数，否则返回运行时错误。

`deleted_items := splice(array[, start[, delete_count[, item1[, item2[, ...]]]])`

```go
v := [1, 2, 3]
items := splice(v, 0) // items == [1, 2, 3], v == []
```

```go
v := [1, 2, 3]
items := splice(v, 1) // items == [2, 3], v == [1]
```

```go
v := [1, 2, 3]
items := splice(v, 0, 1) // items == [1], v == [2, 3]
```

```go
// deleting
v := ["a", "b", "c"]
items := splice(v, 1, 2) // items == ["b", "c"], v == ["a"]
// splice(v, 1, 3) or splice(v, 1, 99) has same effect for this example
```

```go
// appending
v := ["a", "b", "c"]
items := splice(v, 3, 0, "d", "e") // items == [], v == ["a", "b", "c", "d", "e"]
```

```go
// replacing
v := ["a", "b", "c"]
items := splice(v, 2, 1, "d") // items == ["c"], v == ["a", "b", "d"]
```

```go
// inserting
v := ["a", "b", "c"]
items := splice(v, 0, 0, "d", "e") // items == [], v == ["d", "e", "a", "b", "c"]
```

```go
// deleting and inserting
v := ["a", "b", "c"]
items := splice(v, 1, 1, "d", "e") // items == ["b"], v == ["a", "d", "e", "c"]
```

## type_name

返回对象的类型名称。

```go
type_name(1) // int
type_name("str") // string
type_name([1, 2, 3]) // array
```

## string

尝试将对象转换为字符串对象。

```go
x := string(123) //  x == "123"
```

## int

尝试将对象转换为int对象。

```go
v := int("123") //  v == 123
```

## bool

尝试将对象转换为bool对象。

```go
v := bool(1) //  v == true
```

## float

尝试将对象转换为float对象。

```go
v := float("19.84") //  v == 19.84
```

## char

尝试将对象转换为char对象。

```go
v := char(89) //  v == 'Y'
```

## bytes

尝试将对象转换为bytes对象。

```go
v := bytes("foo") //  v == [102 111 111]
```

如果将int传递给“bytes()”函数，它将创建一个给定大小的新字节对象。

```go
v := bytes(100)
```

## time

尝试将对象转换为time对象。

```go
v := time(1257894000) // 2009-11-10 23:00:00 +0000 UTC
```

## is_string

如果对象的类型为字符串，则返回“true”。或者返回“false”。

## is_int

如果对象的类型为int，则返回“true”。或者返回“false”。

## is_bool

如果对象的类型为bool，则返回“true”。或者返回“false”。

## is_float

如果对象的类型为float，则返回“true”。或者返回“false”。

## is_char

如果对象的类型为char，则返回“true”。或者返回“false”。

## is_bytes

如果对象的类型为bytes，则返回“true”。或者返回“false”。

## is_error

如果对象的类型为error，则返回“true”。或者返回“false”。

## is_nil

如果对象的类型为nil，则返回“true”。或者返回“false”。

## is_function

如果对象的类型是函数或闭包，则返回“true”。或者返回“false”。请注意，对于内置函数和用户提供的可调用对象，“is_function”返回“false”。

## is_callable

如果对象是可调用的（例如函数、闭包、内置函数或用户提供的可调用对象），则返回“true”。或者返回“false”。

## is_array

如果对象的类型为数组，则返回“true”。或者返回“false”。

## is_const_array

如果对象的类型为常量数组，则返回“true”。或者返回“false”。

## is_map

如果对象的类型是映射，则返回“true”。或者返回“false”。

## is_const_map

如果对象的类型为常量映射，则返回“true”。或者返回“false”。

## is_iterable

如果对象的类型是可迭代的，则返回“true”：数组、常量数组、映射、常量映射、字符串和字节是DSL中的可迭代类型。

## is_time

如果对象的类型是时间，则返回“true”。或者返回“false”。

## is_time

如果对象的类型是时间，则返回“true”。或者返回“false”。

## base64(src interface) string

对字符串进行base64编码。

```go
base64("Hello")
```

## base64_decode(src interface) bytes

对字符串进行base64解码。

```go
base64_decode("SGVsbG8=")
```

## base64_py(src interface) string

像python一样将字符串编码为base64（使用新行）。

```go
base64_py("Hello")
```

## compare_versions(versionToCheck string, constraints …string) bool

将第一个版本参数与提供的约束进行比较。

```go
compare_versions('v1.0.0', '\>v0.0.1', '\<v1.0.1')
```

## contains(input, substring interface) bool

验证字符串是否包含子字符串。

```go
contains("Hello", "lo")
```

## contains_all(input interface, substrings …string) bool

验证任何输入是否包含所有子字符串。

```go
contains_all("Hello everyone", "lo", "every")
```

## contains_any(input interface, substrings …string) bool

验证输入是否包含任何子字符串。

```go
contains_any("Hello everyone", "abc", "llo")
```

## date_time(format string, optionalUnixTime interface) string

使用简化或go样式布局返回当前或给定unix时间的格式化日期时间。

```go
date_time("%Y-%M-%D %H:%m")
date_time("%Y-%M-%D %H:%m", 1654870680)
date_time("2006-01-02 15:04", unix_time())
```

## ends_with(str string, suffix …string) bool

检查字符串是否以提供的任何子字符串结尾。

```go
ends_with("Hello", "lo")
```

## generate_java_gadget(gadget, cmd, encoding interface) string

生成Java反序列化小工具。

```go
generate_java_gadget("dns", "{{interactsh-url}}", "base64")
```

## generate_jwt(json, algorithm, signature, unixMaxAge) string

使用JSON字符串中提供的声明、签名和指定的算法生成JSON Web令牌（JWT）。

```go
generate_jwt("{\"name\":\"John Doe\",\"foo\":\"bar\"}", "HS256", "hello-world")
```

## hex_decode(input interface) bytes

十六进制解码给定的输入。

```go
hex_decode("6161")
```

## hex_encode(input interface) string

十六进制编码给定的输入。

```go
hex_encode("aa")
```

## hmac(algorithm, data, secret) string

hmac函数，它接受具有数据和机密的哈希函数类型。

```go
hmac("sha1", "test", "scrt")
```

## html_escape(input interface) string

HTML转义给定的输入。

```go
html_escape("\<body\>test\</body\>")
```

## html_unescape(input interface) string

HTML取消转义给定的输入。

```go
html_unescape("&lt;body&gt;test&lt;/body&gt;")
```

## json_minify(json) string

通过删除不必要的空白来最小化JSON字符串。

```go
json_minify("{ \"name\": \"John Doe\", \"foo\": \"bar\" }")
```

## json_prettify(json) string

通过添加缩进来美化JSON字符串。

```go
json_prettify("{\"foo\":\"bar\",\"name\":\"John Doe\"}")
```

## md5(input interface) string

计算输入的MD5（消息摘要）哈希。

```go
md5("Hello")
```

## mmh3(input interface) string

计算输入的MMH3（MurmurHash3）哈希。

```go
mmh3("Hello")
```

## rand_base(length uint, optionalCharSet string) string

从可选字符集生成给定长度的随机字符串序列（默认为字母和数字）。

```go
rand_base(5, "abc")
```

## rand_int(optionalMin, optionalMax uint) int

生成给定可选限制之间的随机整数（默认为0-MaxInt32）。

```go
rand_int(1, 10)
```

## rand_text_alpha(length uint, optionalBadChars string) string

生成给定长度的随机字母字符串，不包括可选的剪切集字符。

```go
rand_text_alpha(10, "abc")
```

## rand_text_alphanumeric(length uint, optionalBadChars string) string

生成一个给定长度的随机字母数字字符串，不包含可选的剪切集字符。

```go
rand_text_alphanumeric(10, "ab12")
```

## rand_text_numeric(length uint, optionalBadNumbers string) string

生成给定长度的随机数字字符串，不包含可选的一组不需要的数字。

```go
rand_text_numeric(10, 123)
```

## regex(pattern, input string) bool

针对输入字符串测试给定的正则表达式。

```go
regex("H([a-z]+)o", "Hello")
```

## repeat(str string, count uint) string

将输入字符串重复给定次数。

```go
repeat("../", 5)
```

## replace(str, old, new string) string

替换给定输入中的给定子字符串。

```go
replace("Hello", "He", "Ha")
```

## replace_regex(source, regex, replacement string) string

替换输入中与给定正则表达式匹配的子字符串。

```go
replace_regex("He123llo", "(\\d+)", "")
```

## reverse(input string) string

反转给定的输入。

```go
reverse("abc")
```

## sha1(input interface) string

计算输入的SHA1（安全哈希1）哈希。

```go
sha1("Hello")
```

## sha256(input interface) string

计算输入的SHA256（安全哈希256）哈希。

```go
sha256("Hello")
```

## starts_with(str string, prefix …string) bool

检查字符串是否以提供的任何子字符串开头。

```go
starts_with("Hello", "He")
```

## to_lower(input string) string

将输入转换为小写字符。

```go
to_lower("HELLO")
```

## to_upper(input string) string

将输入转换为大写字符。

```go
to_upper("hello")
```

## trim(input, cutset string) string

返回一个已删除割集中包含的所有前导和尾随Unicode代码点的输入片段。

```go
trim("aaaHelloddd", "ad")
```

## trim_left(input, cutset string) string

返回一个已删除割集中包含的所有前导Unicode代码点的输入片段。

```go
trim_left("aaaHelloddd", "ad")
```

## trim_prefix(input, prefix string) string

返回没有提供前导前缀字符串的输入。

```go
trim_prefix("aaHelloaa", "aa")
```

## trim_right(input, cutset string) string

返回一个字符串，删除了剪切集中包含的所有尾随Unicode代码点。

```go
trim_right("aaaHelloddd", "ad")
```

## trim_space(input string) string

返回一个字符串，其中删除了Unicode定义的所有前导和尾部空格。

```go
trim_space(" Hello ")
```

## trim_suffix(input, suffix string) string

返回不带提供的尾部后缀字符串的输入。

```go
trim_suffix("aaHelloaa", "aa")
```

## unix_time(optionalSeconds uint) float64

返回当前Unix时间（自1970年1月1日UTC以来经过的秒数）以及添加的可选秒数。

```go
unix_time(10)
```

## url_decode(input string) string

URL对输入字符串进行解码。

```go
url_decode("https:%2F%2Fprojectdiscovery.io%3Ftest=1")
```

## url_encode(input string) string

URL对输入字符串进行编码。

```go
url_encode("https://projectdiscovery.io/test?a=1")
```

## wait_for(seconds uint)

将执行暂停给定的秒数。

```go
wait_for(10)
```



# 库 - "http"

```go
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

```go
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
