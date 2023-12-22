# VDSL语法

VDSL的语法设计为Go开发人员所熟悉，同时更简单、更精简。

**您可以在CVE PoC IDE中测试VDSL代码**

## 值和值类型

在VDSL中，一切都是一个值，并且所有值都与一个类型相关联。

```golang
11 + 22               // int 值
"aa" + `bb`     // string 值
-1.22 + 3e9          // float 值
true || false         // bool 值
'七' > '7'             // char 值
[33, false, "xx"]     // array 值
{a: true, b: "oo"}  // map 值
func() { /*...*/ }    // function 值
```

以下是VDSL中所有可用值类型的列表。

| VDSL 类型 | 描述 | go中的等效类型 |
| :---: | :---: | :---: |
| int | 有符号64位整数值 | `int64` |
| float | 64位浮点值 | `float64` |
| bool | 布尔值 | `bool` |
| char | unicode字符 | `rune` |
| string | unicode字符串 | `string` |
| bytes | 字节数组 | `[]byte` |
| error | [错误](#error-values) 值 | - |
| time | 时间值 | `time.Time` |
| array | 值数组_(可变 )_ | `[]any` |
| const array | [常量](#const-values) 数组 | - |
| map | 具有字符串键的值映射 _(可变)_ | `map[string]any` |
| const map | [常量](#const-values) 映射 | - |
| nil | [nil](#nil-values) 值 | - |
| function | [函数](#function-values) 值 | - |
| _user-defined_ | 用户定义类型 | - |

### Error 值

在VDSL中，可以使用“error”类型的值来表示错误。一个错误值是使用“error”表达式创建的，并且它必须有一个底层值可以使用`.value`访问错误值的基础值选择器。

```golang
err1 := error("oops")    // error with string value
err2 := error(1+2+3)     // error with int value
if is_error(err1) {      // 'is_error' builtin function
  err_val := err1.value  // get underlying value
}
```

### Const 值

在VDSL中，基本上所有的值（除了数组和映射）都是常量。

```golang
s := "12345"
s[1] = 'b'    // illegal: String is const

a := [1, 2, 3]
a[1] = "two"  // ok: a is now [1, "two", 3]
```

可以使用“const”表达式将数组或映射值设为const。

```golang
b := const([1, 2, 3])
b[1] = "foo"  // illegal: 'b' references to an const array.
```

请注意，将新值重新分配给变量与值不变性不冲突。

```golang
s := "abc"
s = "foo"                  // ok
a := const([1, 2, 3])
a = false                  // ok
```

请注意，如果复制（使用“copy”内置函数）常量值将返回一个“可变”副本。此外，不变性不适用于数组或映射值的各个元素，除非它们是显式生成的常量。

```golang
a := const({b: 4, c: [1, 2, 3]})
a.b = 5        // illegal
a.c[1] = 5     // ok: because 'a.c' is not const

a = const({b: 4, c: const([1, 2, 3])})
a.c[1] = 5     // illegal
```

### Nil 值

在VDSL中，“nil”值可用于表示意外的或不存在的值:

- 一个函数，它不返回或明确返回`nil`值，都被认为返回nil值。
- 如果键或索引不存在，则复合值类型的索引器或选择器可能返回`nil`。
- 如果转换失败，没有默认值的类型转换内置函数将返回“nil”。

```golang
a := func() { b := 4 }()    // a == nil
b := [1, 2, 3][10]          // b == nil
c := {a: "foo"}["b"]        // c == nil
d := int("foo")             // d == nil
```

### Array 值

在VDSL中，数组是任何类型的值的有序列表。可以使用索引器“[]”访问数组的元素。

```golang
[1, 2, 3][0]       // == 1
[1, 2, 3][2]       // == 3
[1, 2, 3][3]       // == nil

["foo", "bar", [1, 2, 3]]   // ok: array with an array element
```

### Map 值

在VDSL中，map是一组键值对，其中key是字符串，value是任何值类型。可以使用索引器“[]”或选择器“”访问映射的值操作员。

```golang
m := { a: 1, b: false, c: "foo" }
m["b"]                                // == false
m.c                                   // == "foo"
m.x                                   // == nil

{a: [1,2,3], b: {c: "foo", d: "bar"}} // ok: map with an array element and a map element
```

### Function 值

在VDSL中，函数是一个具有多个函数参数和一个返回值的可调用值。就像任何其他值一样，函数可以传递到另一个函数中，也可以从该函数返回。

```golang
my_func := func(arg1, arg2) {
  return arg1 + arg2
}

adder := func(base) {
  return func(x) { return base + x }  // capturing 'base'
}
add5 := adder(5)
nine := add5(4)    // == 9
```

与Go不同，VDSL没有声明。因此，以下代码是非法的：

```golang
func my_func(arg1, arg2) {  // illegal
  return arg1 + arg2
}
```

VDSL还支持可变函数/闭包：

```golang
variadic := func (a, b, ...c) {
  return [a, b, c]
}
variadic(1, 2, 3, 4) // [1, 2, [3, 4]]

variadicClosure := func(a) {
  return func(b, ...c) {
    return [a, b, c]
  }
}
variadicClosure(1)(2, 3, 4) // [1, 2, [3, 4]]
```

只有最后一个参数可以是可变的。以下代码也是非法的：

```golang
// illegal, because a is variadic and is not the last parameter
illegal := func(a..., b) { /*... */ }
```

调用函数时，传递参数的数量必须与该函数定义相匹配。

```golang
f := func(a, b) {}
f(1, 2, 3) // Runtime Error: wrong number of arguments: want=2, got=3
```

像Go一样，您可以使用省略号“…”要传递数组类型值作为其最后一个参数：

```golang
f1 := func(a, b, c) { return a + b + c }
f1([1, 2, 3]...)    // => 6
f1(1, [2, 3]...)    // => 6
f1(1, 2, [3]...)    // => 6
f1([1, 2]...)       // Runtime Error: wrong number of arguments: want=3, got=2

f2 := func(a, ...b) {}
f2(1)               // valid; a = 1, b = []
f2(1, 2)            // valid; a = 1, b = [2]
f2(1, 2, 3)         // valid; a = 1, b = [2, 3]
f2([1, 2, 3]...)    // valid; a = 1, b = [2, 3]
```

## 变量和范围

可以使用赋值运算符“：=”和“=”将值赋值给变量。

- `:=`运算符在作用域中定义一个新变量并赋值。
- `=`运算符为作用域中的现有变量分配一个新值。

变量在全局范围（在函数外部定义）或本地范围（在功能内部定义）中定义。

```golang
a := "foo"      // define 'a' in global scope

func() {        // function scope A
  b := 52       // define 'b' in function scope A

  func() {      // function scope B
    c := 19.84  // define 'c' in function scope B

    a = "bee"   // ok: assign new value to 'a' from global scope
    b = 20      // ok: assign new value to 'b' from function scope A

    b := true   // ok: define new 'b' in function scope B
                //     (shadowing 'b' from function scope A)
  }

  a = "bar"     // ok: assigne new value to 'a' from global scope
  b = 10        // ok: assigne new value to 'b'
  a := -100     // ok: define new 'a' in function scope A
                //     (shadowing 'a' from global scope)

  c = -9.1      // illegal: 'c' is not defined
  b := [1, 2]   // illegal: 'b' is already defined in the same scope
}

b = 25          // illegal: 'b' is not defined
a := {d: 2}     // illegal: 'a' is already defined in the same scope
```

与Go不同，可以为变量指定不同类型的值。

```golang
a := 123        // assigned    'int'
a = "123"       // re-assigned 'string'
a = [1, 2, 3]   // re-assigned 'array'
```

## 类型转换

虽然VDSL中没有直接指定类型，但可以使用类型转换在值类型之间进行转换。

```golang
s1 := string(1984)    // "1984"
i2 := int("-999")     // -999
f3 := float(-51)      // -51.0
b4 := bool(1)         // true
c5 := char("X")       // 'X'
```

## 操作符

### 单目运算符

| Operator | Usage | Types |
| :---: | :---: | :---: |
| `+`   | same as `0 + x` | int, float |
| `-`   | same as `0 - x` | int, float |
| `!`   | logical NOT | all types* |
| `^`   | bitwise complement | int |

在VDSL中，所有值都可以是真值也可以是假值

### Binary Operators

| Operator | Usage | Types |
| :---: | :---: | :---: |
| `==` | equal | all types |
| `!=` | not equal | all types |
| `&&` | logical AND | all types |
| `\|\|` | logical OR | all types |
| `+`   | add/concat | int, float, string, char, time, array |
| `-`   | subtract | int, float, char, time |
| `*`   | multiply | int, float |
| `/`   | divide | int, float |
| `&`   | bitwise AND | int |
| `\|`   | bitwise OR | int |
| `^`   | bitwise XOR | int |
| `&^`   | bitclear (AND NOT) | int |
| `<<`   | shift left | int |
| `>>`   | shift right | int |
| `<`   | less than | int, float, char, time, string |
| `<=`   | less than or equal to | int, float, char, time, string |
| `>`   | greater than | int, float, char, time, string |
| `>=`   | greater than or equal to | int, float, char, time, string |

### 三目操作符

VDSL有一个三元条件运算符`（条件表达式）？（true表达式）：（false表达式）`。

```golang
a := true ? 1 : -1    // a == 1

min := func(a, b) {
  return a < b ? a : b
}
b := min(5, 10)      // b == 5
```

### 赋值和增量运算符

| Operator | Usage |
| :---: | :---: |
| `+=` | `(lhs) = (lhs) + (rhs)` |
| `-=` | `(lhs) = (lhs) - (rhs)` |
| `*=` | `(lhs) = (lhs) * (rhs)` |
| `/=` | `(lhs) = (lhs) / (rhs)` |
| `%=` | `(lhs) = (lhs) % (rhs)` |
| `&=` | `(lhs) = (lhs) & (rhs)` |
| `\|=` | `(lhs) = (lhs) \| (rhs)` |
| `&^=` | `(lhs) = (lhs) &^ (rhs)` |
| `^=` | `(lhs) = (lhs) ^ (rhs)` |
| `<<=` | `(lhs) = (lhs) << (rhs)` |
| `>>=` | `(lhs) = (lhs) >> (rhs)` |
| `++` | `(lhs) = (lhs) + 1` |
| `--` | `(lhs) = (lhs) - 1` |

### 操作符优先级

一元运算符具有最高优先级，三元运算符具有最低优先级。二进制运算符有五个优先级。

乘法运算符绑定最强，其次是加法运算符，比较运算符，“&&”（逻辑AND），最后是“||”（逻辑OR）：

| 优先级 | 操作符 |
| :---: | :---: |
| 5 | `*`  `/`  `%`  `<<`  `>>`  `&`  `&^` |
| 4 | `+`  `-`  `\|`  `^` |
| 3 | `==`  `!=`  `<`  `<=`  `>`  `>=` |
| 2 | `&&` |
| 1 | `\|\|` |

与Go一样，“++”和“--”运算符形成语句，而不是表达式，它们位于运算符层次结构之外。

### 选择器和索引器

可以使用选择器（`.`）和索引器（`[]`）运算符来读取或写入复合类型（数组、映射、字符串、字节）的元素。

```golang
["one", "two", "three"][1]  // == "two"

m := {
  a: 1,
  b: [2, 3, 4],
  c: func() { return 10 }
}
m.a              // == 1
m["b"][1]        // == 3
m.c()            // == 10
m.x = 5          // add 'x' to map 'm'
m["b"][5]        // == nil
m["b"][5].d      // == nil
m.b[5] = 0       // == nil
m.x.y.z          // == nil
```

与Go一样，可以对数组、字符串、字节等序列值类型使用切片运算符“[:]”。

```golang
a := [1, 2, 3, 4, 5][1:3]    // == [2, 3]
b := [1, 2, 3, 4, 5][3:]     // == [4, 5]
c := [1, 2, 3, 4, 5][:3]     // == [1, 2, 3]
d := "hello world"[2:10]     // == "llo worl"
c := [1, 2, 3, 4, 5][-1:10]  // == [1, 2, 3, 4, 5]
```

**注意：关键字不能用作选择器**

```golang
a := {in: true} // Parse Error: expected map key, found 'in'
a.func = ""     // Parse Error: expected selector, found 'func'
```

使用双引号和索引器将关键字与映射一起使用。

```golang
a := {"in": true}
a["func"] = ""
```

## 语句

### If 语句

“If”语句与Go非常相似。

```golang
if a < 0 {
  // execute if 'a' is negative
} else if a == 0 {
  // execute if 'a' is zero
} else {
  // execute if 'a' is positive
}
```

与Go一样，条件表达式前面可能有一个简单的语句，该语句在计算表达式之前执行。

```golang
if a := foo(); a < 0 {
  // execute if 'a' is negative
}
```

### For 语句

“For”语句与Go非常相似。

```golang
// for (init); (condition); (post) {}
for a:=0; a<10; a++ {
  // ...
}

// for (condition) {}
for a < 10 {
  // ...
}

// for {}
for {
  // ...
}
```

### For-In 语句

VDSL中新增了“For In”语句。它类似于Go的“for range”语句。

“For In”语句可以迭代任何可迭代的值类型（数组、映射、字节、字符串、nil）。

```golang
for v in [1, 2, 3] {          // array: element
  // 'v' is value
}
for i, v in [1, 2, 3] {       // array: index and element
  // 'i' is index
  // 'v' is value
}
for k, v in {k1: 1, k2: 2} {  // map: key and value
  // 'k' is key
  // 'v' is value
}
```

## 模块

模块是VDSL中的基本编译单元。一个模块可以使用“import”表达式导入另一个模块。

主模块:

```golang
sum := import("./sum")  // load module from a local file
fmt.print(sum(10))      // module function
```

“sum.dsl”文件中的另一个模块:

```golang
base := 5

export func(x) {
  return x + base
}
```

默认情况下，“import”将模块文件缺少的扩展名解决为"`.dsl`"[^note]。
因此，“sum:=import（"./sum"）”相当于“sum:=import（"./sum.dsl"）”。

[^note]:
    如果在Go中使用VDSL作为库，则可以自定义文件扩展名“`.dsl`”。在这种情况下，请使用“Compiler”类型的“SetImportFileExt”函数。
    
    请参阅[转到参考](https://pkg.go.dev/dsl)详细信息。

在VDSL中，模块与函数非常相似。

- `import` 表达式加载模块代码并像函数一样执行它。
- 模块应使用“export”语句返回一个值。
  - 模块可以返回“导出”任何类型的值：int、map、function等。
  - 模块中的export类似于函数中的return：它停止执行并导入代码返回一个值。
  - `export`的值总是常量。
  - 如果模块没有任何“export”语句，则“import”表达式只返回“nil”_（就像没有“return”的函数一样。）_
  - 请注意，如果代码作为主模块执行，则“export”语句将被完全忽略，并且不会进行求值。

此外，您还可以使用“import”表达式来加载标准库。

```golang
math := import("math")
a := math.abs(-19.84)  // == 19.84
```

## Comments

与Go一样，VDSL支持行注释（`//…`）和块注释(`/* ... */`).

```golang
/*
  multi-line block comments
*/

a := 5    // line comments
```

## 与Go的区别

与Go不同，VDSL没有以下功能：

- Declarations
- Imaginary values
- Structs
- Pointers
- Channels
- Goroutines
- Tuple assignment
- Variable parameters
- Switch statement
- Goto statement
- Defer statement
- Panic
- Type assertion
