# 查询语法

**资产查询**使用的是一种简单的表达式语言，可用于计算表达式。

## 数据类型

<table>
    <tr>
        <td><strong>注释</strong></td>
        <td>
             <code>/* */</code> or <code>//</code>
        </td>
    </tr>
    <tr>
        <td><strong>布尔型</strong></td>
        <td>
            <code>true</code>, <code>false</code>
        </td>
    </tr>
    <tr>
        <td><strong>整型</strong></td>
        <td>
            <code>42</code>, <code>0x2A</code>, <code>0o52</code>, <code>0b101010</code>
        </td>
    </tr>
    <tr>
        <td><strong>浮点型</strong></td>
        <td>
            <code>0.5</code>, <code>.5</code>
        </td>
    </tr>
    <tr>
        <td><strong>字符串型</strong></td>
        <td>
            <code>"foo"</code>, <code>'bar'</code>
        </td>
    </tr>
    <tr>
        <td><strong>数组型</strong></td>
        <td>
            <code>[1, 2, 3]</code>
        </td>
    </tr>
    <tr>
        <td><strong>Map型</strong></td>
        <td>
            <code>&#123;a: 1, b: 2, c: 3&#125;</code>
        </td>
    </tr>
    <tr>
        <td><strong>Nil型</strong></td>
        <td>
            <code>nil</code>
        </td>
    </tr>
</table>


### 字符串

字符串可以用单引号或双引号括起来。字符串可以包含转义序列，例如换行符的“\n”，`\t`表示制表符，`\uXXXX`表示Unicode代码点。

```go
"Hello\nWorld"
```

对于多行字符串，请使用反标记：

```go
`Hello
World`
```

反标记字符串是原始字符串，不支持转义序列。

## 操作符

<table>
    <tr>
        <td><strong>算术运算</strong></td>
        <td>
            <code>+</code>, <code>-</code>, <code>*</code>, <code>/</code>, <code>%</code> , <code>^</code> 或 <code>**</code> (指数)
        </td>
    </tr>
    <tr>
        <td><strong>比较运算</strong></td>
        <td>
            <code>==</code>, <code>!=</code>, <code>&lt;</code>, <code>&gt;</code>, <code>&lt;=</code>, <code>&gt;=</code>
        </td>
    </tr>
    <tr>
        <td><strong>逻辑运算</strong></td>
        <td>
            <code>not</code> 或 <code>!</code>, <code>and</code> 或 <code>&amp;&amp;</code>, <code>or</code> 或 <code>||</code>
        </td>
    </tr>
    <tr>
        <td><strong>条件运算</strong></td>
        <td>
            <code>?:</code> (三元组), <code>??</code> (nil 合并)
        </td>
    </tr>
    <tr>
        <td><strong>关系运算</strong></td>
        <td>
            <code>[]</code>, <code>.</code>, <code>?.</code>, <code>in</code>
        </td>
    </tr>
    <tr>
        <td><strong>字符串运算</strong></td>
        <td>
            <code>+</code> (连接), <code>contains</code>, <code>startsWith</code>, <code>endsWith</code>
        </td>
    </tr>
    <tr>
        <td><strong>正则运算</strong></td>
        <td>
            <code>matches</code>
        </td>
    </tr>
    <tr>
        <td><strong>范围运算</strong></td>
        <td>
            <code>..</code>
        </td>
    </tr>
    <tr>
        <td><strong>切片</strong></td>
        <td>
            <code>[:]</code>
        </td>
    </tr>
    <tr>
        <td><strong>管道</strong></td>
        <td>
            <code>|</code>
        </td>
    </tr>
</table>


### 成员运算符

结构的字段和映射的项可以用`.`访问运算符或“[]”运算符。接下来的两个表达式是等效的：

```go
user.Name
user["Name"]
```

可以使用“[]”运算符访问数组和切片的元素。支持负索引，“-1”是最后一个元素。

```go
array[0] // first element
array[-1] // last element
```

“in”运算符可用于检查项是否在数组或映射中。

```go
"John" in ["John", "Jane"]
"name" in {"name": "John", "age": 30}
```

#### 可选链

这个运算符可用于访问结构的字段或映射的项，而无需检查该结构或映射是否为“nil”。如果结构或映射为“nil”，则表达式的结果为“nil”。

```go
author.User?.Name
```

等效于：

```go
author.User != nil ? author.User.Name : nil
```

#### Nil 合并

这个运算符可用于返回不为“nil”的左侧，否则返回右侧。

```go
author.User?.Name ?? "Anonymous"
```

等效于：

```go
author.User != nil ? author.User.Name : "Anonymous"
```

### 切片运算符

切片运算符“[:]”可用于访问数组的切片。

例如，变量**数组** `[1, 2, 3, 4, 5]`:

```go
array[1:4] == [2, 3, 4]
array[1:-1] == [2, 3, 4]
array[:3] == [1, 2, 3]
array[3:] == [4, 5]
array[:] == array
```

### 管道操作符

管道运算符“|”可用于传递左侧表达式的结果作为右侧表达式的第一个参数。

```go
user.Name | lower() | split(" ")
```

等效于：

```go
split(lower(user.Name), " ")
```

### 范围运算符

范围运算符`..`可以用于创建一系列整数。

```go
1..3 == [1, 2, 3]
```

## 变量

变量可以用“let”关键字声明。变量名必须以字母或下划线开头。变量名称可以包含字母、数字和下划线。声明变量后，就可以在表达式中使用该变量。

```go
let x = 42; x * 2
```

多个变量可以用分号分隔的“let”语句声明。

```go
let x = 42; 
let y = 2; 
x * y
```

以下是带有管道运算符的变量示例：

```go
let name = user.Name | lower() | split(" "); 
"Hello, " + name[0] + "!"
```

### $env

“$env”变量是传递给表达式的所有变量的映射。

```go
foo.Name == $env["foo"].Name
$env["var with spaces"]
```

将“$env”视为包含所有变量的全局变量。

“$env”可用于检查是否定义了变量：

```go
'foo' in $env
```

## 断言

断言是一个表达式。断言可以用于“filter”、“all”、“any”、“one”、“none”等函数。
例如，下一个表达式创建一个从0到9的新数组，然后按偶数进行筛选：

```go
filter(0..9, {# % 2 == 0})
```

如果数组的项是结构或映射，则可以访问带有省略的“#”符号的字段（“#.Value”变为“.Value’”）。

```go
filter(tweets, {len(.Content) > 240})
```

大括号“｛` `｝”可以省略：

```go
filter(tweets, len(.Content) > 240)
```

提示
在嵌套谓词中，要访问外部变量，请使用[variables]（#variables）。

```go
filter(posts, {
    let post = #; 
    any(.Comments, .Author == post.Author)
}) 
```

:::

## 字符串函数

### trim(str[, chars]) {#trim}

删除字符串“str”两端的空白。如果给定了可选的“chars”参数，则它是一个指定要删除的字符集的字符串。

```go
trim("  Hello  ") == "Hello"
trim("__Hello__", "_") == "Hello"
```

### trimPrefix(str, prefix) {#trimPrefix}

从字符串“str”中删除指定的前缀（如果该字符串以该前缀开头）。

```go
trimPrefix("HelloWorld", "Hello") == "World"
```

### trimSuffix(str, suffix) {#trimSuffix}

如果字符串“str”以指定的后缀结尾，则从该字符串中删除该后缀。

```go
trimSuffix("HelloWorld", "World") == "Hello"
```

### upper(str) {#upper}

将字符串“str”中的所有字符转换为大写。

```go
upper("hello") == "HELLO"
```

### lower(str) {#lower}

将字符串“str”中的所有字符转换为小写。

```go
lower("HELLO") == "hello"
```

### split(str, delimiter[, n]) {#split}

在分隔符的每个实例处拆分字符串“str”，并返回一个子字符串数组。

```go
split("apple,orange,grape", ",") == ["apple", "orange", "grape"]
split("apple,orange,grape", ",", 2) == ["apple", "orange,grape"]
```

### splitAfter(str, delimiter[, n]) {#splitAfter}

在分隔符的每个实例后面拆分字符串“str”。

```go
splitAfter("apple,orange,grape", ",") == ["apple,", "orange,", "grape"]
splitAfter("apple,orange,grape", ",", 2) == ["apple,", "orange,grape"]
```

### replace(str, old, new) {#replace}

将字符串“str”中所有出现的“old”替换为“new”。

```go
replace("Hello World", "World", "Universe") == "Hello Universe"
```

### repeat(str, n) {#repeat}

重复字符串“str”“n”次。

```go
repeat("Hi", 3) == "HiHiHi"
```

### indexOf(str, substring) {#indexOf}

返回字符串“str”中第一个出现的子字符串的索引，如果未找到，则返回-1。

```go
indexOf("apple pie", "pie") == 6
```

### lastIndexOf(str, substring) {#lastIndexOf}

返回字符串“str”中最后一个出现的子字符串的索引，如果未找到，则返回-1。

```go
lastIndexOf("apple pie apple", "apple") == 10
```

### hasPrefix(str, prefix) {#hasPrefix}

如果字符串“str”以给定前缀开头，则返回“true”。

```go
hasPrefix("HelloWorld", "Hello") == true
```

### hasSuffix(str, suffix) {#hasSuffix}

如果字符串“str”以给定后缀结尾，则返回“true”。

```go
hasSuffix("HelloWorld", "World") == true
```

## 日期函数

可以减去两个日期，得到它们之间的间隔时间：

```go
createdAt - now()
```

可以为日期添加持续时间：

```go
createdAt + duration("1h")
```

并且可以比较日期：

```go
createdAt > now() - duration("1h")
```

### now() {#now}

将当前日期返回为[time.time](https://pkg.go.dev/time#Time)值

```go
now().Year() == 2024
```

### duration(str) {#duration}

返回给定字符串“str”的[time.Duration](https://pkg.go.dev/time#Duration)值。

有效的时间单位为“ns”、“us”（或“µs”）、“ms”、“s”、“m”、“h”。

```go
duration("1h").Seconds() == 3600
```

### date(str[, format[, timezone]]) {#date}

将给定的字符串“str”转换为日期表示形式。如果给定了可选的“format”参数，则它是一个指定日期格式的字符串。格式字符串使用与标准Go [时间包](https://pkg.go.dev/time#pkg-constants)相同的格式规则。如果给定了可选的“时区”参数，则它是一个指定日期时区的字符串。如果未给定“format”参数，则“v”参数必须采用以下格式之一：

- 2006-01-02
- 15:04:05
- 2006-01-02 15:04:05
- RFC3339
- RFC822,
- RFC850,
- RFC1123,

```go
date("2023-08-14")
date("15:04:05")
date("2023-08-14T00:00:00Z")
date("2023-08-14 00:00:00", "2006-01-02 15:04:05", "Europe/Zurich")
```

日期的可用方法：

- `Year()` 
- `Month()` 
- `Day()` 
- `Hour()` 
- `Minute()` 
- `Second()` 
- `Weekday()` 
- `YearDay()` 
- and [more](https://pkg.go.dev/time#Time).

```go
date("2023-08-14").Year() == 2023
```

### timezone(str) {#timezone}

返回给定字符串“str”的时区。可用时区列表可在[此处](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)找到.

```go
timezone("Europe/Zurich")
timezone("UTC")
```

要将日期转换为其他时区，请使用[`In()`](https://pkg.go.dev/time#Time.In)方法

```go
date("2023-08-14 00:00:00").In(timezone("Europe/Zurich"))
```

## 数字函数

### max(n1, n2) {#max}

返回两个数字“n1”和“n2”中的最大值。

```go
max(5, 7) == 7
```

### min(n1, n2) {#min}

返回两个数字“n1”和“n2”中的最小值。

```go
min(5, 7) == 5
```

### abs(n) {#abs}

返回一个数字的绝对值。

```go
abs(-5) == 5
```

### ceil(n) {#ceil}

返回大于或等于x的最小整数值。

```go
ceil(1.5) == 2.0
```

### floor(n) {#floor}

返回小于或等于x的最大整数值。

```go
floor(1.5) == 1.0
```

### round(n) {#round}

返回最接近的整数，从零开始取整一半。

```go
round(1.5) == 2.0
```

## 数组函数

### all(array, predicate) {#all}

如果所有元素都满足 [断言](#断言)，则返回**true**。如果数组为空，则返回**true**。

```go
all(tweets, {.Size < 280})
```

### any(array, predicate) {#any}

如果任一元素满足 [断言](#断言)，则返回**true**。如果数组为空，则返回**false**。

```go
any(tweets, {.Size > 280})
```

### one(array, predicate) {#one}

如果恰好有一个元素满足 [断言](#断言)，则返回**true**。如果数组为空，则返回**false**。

```go
one(participants, {.Winner})
```

### none(array, predicate) {#none}

如果所有元素都不满足 [断言](#断言)，则返回**true**。如果数组为空，则返回**true**。

```go
none(tweets, {.Size > 280})
```

### map(array, predicate) {#map}

通过将 [断言](#断言) 应用于数组的每个元素来返回新数组。

```go
map(tweets, {.Size})
```

### filter(array, predicate) {#filter}

通过 [断言](#断言) 过滤数组的元素，返回新数组。

```go
filter(users, .Name startsWith "J")
```

### find(array, predicate) {#find}

查找数组中满足 [断言](#断言) 的第一个元素。

```go
find([1, 2, 3, 4], # > 2) == 3
```

### findIndex(array, predicate) {#findIndex}

查找数组中满足 [断言](#断言) 的第一个元素索引。

```go
findIndex([1, 2, 3, 4], # > 2) == 2
```

### findLast(array, predicate) {#findLast}

查找数组中满足 [断言](#断言) 的最后一个元素。

```go
findLast([1, 2, 3, 4], # > 2) == 4
```

### findLastIndex(array, predicate) {#findLastIndex}

查找数组中满足 [断言](#断言) 的最后一个元素索引。

```go
findLastIndex([1, 2, 3, 4], # > 2) == 3
```

### groupBy(array, predicate) {#groupBy}

根据 [断言](#断言) 的结果对数组的元素进行分组。

```go
groupBy(users, .Age)
```

### count(array[, predicate]) {#count}

返回满足 [断言](#断言) 的元素数。

```go
count(users, .Age > 18)
```

相当于：

```go
len(filter(users, .Age > 18))
```

如果未给定 [断言](#断言) ，则返回数组中“true”元素的数量。

```go
count([true, false, true]) == 2
```

### concat(array1, array2[, ...]) {#concat}

连接两个或多个数组。

```go
concat([1, 2], [3, 4]) == [1, 2, 3, 4]
```

### join(array[, delimiter]) {#join}

使用给定的分隔符将一个字符串数组合并为一个字符串。如果未给定分隔符，则使用空字符串。

```go
join(["apple", "orange", "grape"], ",") == "apple,orange,grape"
join(["apple", "orange", "grape"]) == "appleorangegrape"
```

### reduce(array, predicate[, initialValue]) {#reduce}

将 [断言](#断言) 应用于数组中的每个元素，将数组缩减为单个值。可选的“initialValue”参数可用于指定累加器的初始值。如果没有给定“initialValue”，则使用数组的第一个元素作为初始值。

 [断言](#断言) 中有以下变量：

- `#` - 当前元素
- `#acc` - 累加器
- `#index` - 当前元素的索引

```go
reduce(1..9, #acc + #)
reduce(1..9, #acc + #, 0)
```

### sum(array[, predicate]) {#sum}

返回数组中所有数字的总和。

```go
sum([1, 2, 3]) == 6
```

如果给定了可选的 [断言](#断言) 参数，则它是在求和之前应用于数组的每个元素的 [断言](#断言) 。

```go
sum(accounts, .Balance)
```

相当于：

```go
reduce(accounts, #acc + .Balance, 0)
// or
sum(map(accounts, .Balance))
```

### mean(array) {#mean}

返回数组中所有数字的平均值。

```go
mean([1, 2, 3]) == 2.0
```

### median(array) {#median}

返回数组中所有数字的中值。

```go
median([1, 2, 3]) == 2.0
```

### first(array) {#first}

返回数组中的第一个元素。如果数组为空，则返回“nil”。

```go
first([1, 2, 3]) == 1
```

### last(array) {#last}

返回数组中的最后一个元素。如果数组为空，则返回“nil”。

```go
last([1, 2, 3]) == 3
```

### take(array, n) {#take}

返回数组中的前“n”个元素。如果数组的元素少于“n”个，则返回整个数组。

```go
take([1, 2, 3, 4], 2) == [1, 2]
```

### reverse(array) {#reverse}

返回数组的新反转副本。

```go
reverse([3, 1, 4]) == [4, 1, 3]
reverse(reverse([3, 1, 4])) == [3, 1, 4]
```

### sort(array[, order]) {#sort}

按升序对数组进行排序。可选的“order”参数可用于指定排序顺序：“asc”或“desc”。

```go
sort([3, 1, 4]) == [1, 3, 4]
sort([3, 1, 4], "desc") == [4, 3, 1]
```

### sortBy(array[, predicate, order]) {#sortBy}

根据 [断言](#断言) 的结果对数组进行排序。可选的“order”参数可用于指定排序顺序：“asc”或“desc”。

```go
sortBy(users, .Age)
sortBy(users, .Age, "desc")
```

## Map函数

### keys(map) {#keys}

返回一个数组，该数组包含映射的键。

```go
keys({"name": "John", "age": 30}) == ["name", "age"]
```

### values(map) {#values}

返回一个包含映射值的数组。

```go
values({"name": "John", "age": 30}) == ["John", 30]
```

## 类型转换函数

### type(v) {#type}

返回给定值“v”的类型，返回以下类型之一：

- `nil`
- `bool`
- `int`
- `uint`
- `float`
- `string`
- `array`
- `map`.

对于命名类型和结构，将返回类型名称。

```go
type(42) == "int"
type("hello") == "string"
type(now()) == "time.Time"
```

### int(v) {#int}

返回数字或字符串的整数值。

```go
int("123") == 123
```

### float(v) {#float}

返回数字或字符串的浮点值。

```go
float("123.45") == 123.45
```

### string(v) {#string}

将给定的值“v”转换为字符串表示形式。

```go
string(123) == "123"
```

### toJSON(v) {#toJSON}

将给定的值“v”转换为其JSON字符串表示形式。

```go
toJSON({"name": "John", "age": 30})
```

### fromJSON(v) {#fromJSON}

解析给定的JSON字符串“v”并返回相应的值。

```go
fromJSON('{"name": "John", "age": 30}')
```

### toBase64(v) {#toBase64}

将字符串“v”编码为Base64格式。

```go
toBase64("Hello World") == "SGVsbG8gV29ybGQ="
```

### fromBase64(v) {#fromBase64}

将Base64编码的字符串“v”解码回其原始形式。

```go
fromBase64("SGVsbG8gV29ybGQ=") == "Hello World"
```

### toPairs(map) {#toPairs}

将映射转换为键值对的数组。

```go
toPairs({"name": "John", "age": 30}) == [["name", "John"], ["age", 30]]
```

### fromPairs(array) {#fromPairs}

将键值对的数组转换为映射。

```go
fromPairs([["name", "John"], ["age", 30]]) == {"name": "John", "age": 30}
```

## 其他函数

### len(v) {#len}

返回数组、映射或字符串的长度。

```go
len([1, 2, 3]) == 3
len({"name": "John", "age": 30}) == 2
len("Hello") == 5
```

### get(v, index) {#get}

从数组或映射“v”中检索指定索引处的元素。如果索引超出范围，则返回“nil”。或者密钥不存在，返回“nil”。

```go
get([1, 2, 3], 1) == 2
get({"name": "John", "age": 30}, "name") == "John"
```

## 位函数

### bitand(int, int) {#bitand}

返回由逐位AND运算产生的值。

```go
bitand(0b1010, 0b1100) == 0b1000
```

### bitor(int, int) {#bitor}

返回由按位“或”运算产生的值。

```go
bitor(0b1010, 0b1100) == 0b1110
```

### bitxor(int, int) {#bitxor}

返回由逐位XOR运算产生的值。

```go
bitxor(0b1010, 0b1100) == 0b110
```

### bitnand(int, int) {#bitnand}

返回由逐位AND NOT运算产生的值。

```go
bitnand(0b1010, 0b1100) == 0b10
```

### bitnot(int) {#bitnot}

返回由按位NOT运算产生的值。

```go
bitnot(0b1010) == -0b1011
```

### bitshl(int, int) {#bitshl}

返回左移操作产生的值。

```go
bitshl(0b101101, 2) == 0b10110100
```

### bitshr(int, int) {#bitshr}

返回右移操作产生的值。

```go
bitshr(0b101101, 2) == 0b1011
```

### bitushr(int, int) {#bitushr}

返回无符号右移操作产生的值。

```go
bitushr(-0b101, 2) == 4611686018427387902
```
