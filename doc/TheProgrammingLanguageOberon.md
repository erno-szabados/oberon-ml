# The Programming Language Oberon
## Revision 1.10.2013/3.5.2016
**Niklaus Wirth**

"Make it as simple as possible, but not simpler." (A. Einstein) [cite: 298]

## Table of Contents
1.  History and introduction [cite: 297]
2.  Syntax [cite: 297]
3.  Vocabulary [cite: 297]
4.  Declarations and scope rules [cite: 297]
5.  Constant declarations [cite: 297]
6.  Type declarations [cite: 297]
7.  Variable declarations [cite: 297]
8.  Expressions [cite: 297]
9.  Statements [cite: 297]
10. Procedure declarations [cite: 297]
11. Modules [cite: 297]
Appendix: The Syntax of Oberon [cite: 297]

---

## 1. Introduction
Oberon is a general-purpose programming language that evolved from Modula-2. [cite: 298] Its principal new feature is the concept of type extension, which permits the construction of new data types based on existing ones and relating them. [cite: 299, 300]

This report is a concise reference for programmers, implementors, and manual writers, not a programmer's tutorial. [cite: 301, 302] Unstated information is often intentionally omitted because it can be derived from stated rules or to allow implementor freedom. [cite: 303] This document describes the language as defined in 1988/90 and revised in 2007/2016. [cite: 304]

## 2. Syntax
A language is an infinite set of well-formed sentences defined by its syntax. [cite: 305] In Oberon, these sentences are called compilation units, which are finite sequences of symbols from a finite vocabulary. [cite: 306] The Oberon vocabulary includes identifiers, numbers, strings, operators, delimiters, and comments, which are called lexical symbols and are composed of character sequences. [cite: 307, 308] (Note the distinction between symbols and characters.) [cite: 309]

Extended Backus-Naur Formalism (EBNF) is used to describe the syntax. [cite: 309] Brackets `[` and `]` denote optionality, while braces `{` and `}` denote repetition (possibly zero times). [cite: 310] Syntactic entities (non-terminal symbols) are represented by English words, and language vocabulary symbols (terminal symbols) are represented by strings in quote marks or by words in capital letters. [cite: 311, 312]

## 3. Vocabulary
The following lexical rules apply to symbol composition:
* Blanks and line breaks must not occur within symbols, except in comments and blanks in strings. [cite: 314]
* They are ignored unless necessary to separate two consecutive symbols. [cite: 315]
* Capital and lower-case letters are distinct. [cite: 316]

### Identifiers
Identifiers are sequences of letters and digits, with the first character being a letter. [cite: 317]
`ident = letter {letter | digit}.` [cite: 317]
Examples: `x`, `scan`, `Oberon`, `GetSymbol`, `firstLetter` [cite: 318]

### Numbers
Numbers are unsigned integers or real numbers. [cite: 318]
* Integers are digit sequences and may have a suffix letter. [cite: 319] Without a suffix, the representation is decimal. [cite: 320] The suffix `H` indicates hexadecimal representation. [cite: 320]
* Real numbers always contain a decimal point and optionally a decimal scale factor. [cite: 321] The letter `E` means "times ten to the power of". [cite: 322]

`number = integer | real.` [cite: 323]
`integer = digit {digit} | digit {hexDigit} "H".` [cite: 323]
`real = digit {digit} "." {digit} [ScaleFactor].` [cite: 323]
`ScaleFactor = "E" ["+" | "-"] digit {digit}.` [cite: 324]
`hexDigit = digit | "A" | "B" | "C" | "D" | "E" | "F".` [cite: 325]
`digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9".` [cite: 325]

Examples:
* `1987` [cite: 325]
* `100H` (= 256) [cite: 325]
* `12.3` [cite: 325]
* `4.567E8` (= 456700000) [cite: 325]

### Strings
Strings are character sequences enclosed in quote marks (`"`). [cite: 326] A string cannot contain the delimiting quote mark. [cite: 326] Alternatively, a single-character string can be specified by its ordinal number in hexadecimal notation followed by an `X`. [cite: 326] The number of characters in a string is its length. [cite: 327]

`string = """ {character} """ | digit {hexDigit} "X".` [cite: 328]
Examples: `"OBERON"`, `"Don't worry!"`, `22X` [cite: 328]

### Operators and Delimiters
Operators and delimiters are special characters, character pairs, or reserved words listed below. [cite: 329] Reserved words consist exclusively of capital letters and cannot be used as identifiers. [cite: 329]

| | | | | |
|---|---|---|---|---|
| `+` | `=` | `ARRAY` | `IMPORT` | `THEN` |
| `-` | `(` | `BEGIN` | `IN` | `TO` |
| `*` | `)` | `BY` | `IS` | `TRUE` |
| `/` | `[` | `CASE` | `MOD` | `TYPE` |
| `:` | `]` | `CONST` | `MODULE` | `UNTIL` |
| `;` | `{` | `DIV` | `NIL` | `VAR` |
| `<` | `}` | `DO` | `OF` | `WHILE` |
| `&` | `.` | `ELSE` | `OR` | `(` |
| `<=` | `>` | `ELSIF` | `POINTER` | `)` |
| `>=` | `#` | `END` | `PROCEDURE` | |
| `:=` | `~` | `FALSE` | `RECORD` | |
| `^` | `|` | `FOR` | `REPEAT` | |
| `` ` `` | `` ` `` | `IF` | `RETURN` | |

[cite: 330]

### Comments
Comments can be inserted between any two symbols in a program. [cite: 331] They are arbitrary character sequences opened by `(*` and closed by `*)`. [cite: 332] Comments do not affect program meaning and can be nested. [cite: 333]

## 4. Declarations and Scope Rules
Every identifier in a program must be introduced by a declaration, unless it is predefined. [cite: 334] Declarations specify properties of an object, such as whether it is a constant, type, variable, or procedure. [cite: 335] The identifier then refers to the associated object only within the declaration's scope. [cite: 336, 337] No identifier may denote more than one object within a given scope. [cite: 338]

The scope extends textually from the declaration point to the end of the block (procedure or module) to which the declaration belongs and to which the object is local. [cite: 339] An identifier in the module's scope can be followed by an export mark (`*`) to indicate export from its declaring module. [cite: 340] In this case, the identifier can be used in other modules that import the declaring module, prefixed by the module identifier (e.g., `Module.identifier`). [cite: 341, 342, 343] The prefix and identifier are separated by a period and together form a qualified identifier. [cite: 343]

`qualident = [ident "."] ident.` [cite: 344]
`identdef = ident ["*"].` [cite: 344]

The following identifiers are predefined; their meaning is defined in section 6.1 (types) or 10.2 (procedures): [cite: 345]

| | | | | |
|---|---|---|---|---|
| `ABS` | `ASR` | `ASSERT` | `BOOLEAN` | `BYTE` |
| `CHAR` | `CHR` | `DEC` | `EXCL` | `FLOOR` |
| `FLT` | `INC` | `INCL` | `INTEGER` | `LEN` |
| `LSL` | `NEW` | `ODD` | `ORD` | `PACK` |
| `REAL` | `ROR` | `SET` | `UNPK` | |

[cite: 346]

## 5. Constant Declarations
A constant declaration associates an identifier with a constant value. [cite: 347]
`ConstDeclaration = identdef "=" ConstExpression.` [cite: 347]
`ConstExpression = expression.` [cite: 347]
A constant expression can be evaluated by a textual scan without program execution; its operands are constants. [cite: 348, 349]
Examples:
* `N = 100` [cite: 349]
* `limit = 2*N - 1` [cite: 349]
* `all = {0..WordSize-1}` [cite: 349]
* `name = "Oberon"` [cite: 349]

## 6. Type Declarations
A data type determines the set of values variables of that type may assume and the applicable operators. [cite: 350] A type declaration associates an identifier with a type, defining the structure of variables and implied operators. [cite: 351] There are two data structures: arrays and records, each with different component selectors. [cite: 352]

`TypeDeclaration = identdef "=" type.` [cite: 352]
`type = qualident | ArrayType | RecordType | PointerType | ProcedureType.` [cite: 353]
Examples:

| | | |
|---|---|---|
| `Table` | `=` | `ARRAY N OF REAL` |
| `Tree` | `=` | `POINTER TO Node` |
| `Node` | `=` | `RECORD key: INTEGER;` |
| | | `left, right: Tree` |
| | | `END` |

[cite: 354]
`CenterNode = RECORD (Node) name: ARRAY 32 OF CHAR; subnode: Tree END` [cite: 356]
`Function = PROCEDURE (x: INTEGER): INTEGER` [cite: 356]

### 6.1. Basic Types
The following basic types are denoted by predeclared identifiers. [cite: 357] Their associated operators are defined in 8.2, and predeclared function procedures in 10.2. [cite: 357]

| Type | Values |
|---|---|
| `BOOLEAN` | The truth values `TRUE` and `FALSE` [cite: 359] |
| `CHAR` | The characters of a standard character set [cite: 359] |
| `INTEGER` | The integers [cite: 359] |
| `REAL` | Real numbers [cite: 359] |
| `BYTE` | The integers between 0 and 255 [cite: 359] |
| `SET` | The sets of integers between 0 and an implementation-dependent limit [cite: 359] |

The type `BYTE` is compatible with `INTEGER`, and vice-versa. [cite: 360]

### 6.2. Array Types
An array is a structure with a fixed number of elements, all of the same `element type`. [cite: 361] The `length` is the number of elements. [cite: 362] Elements are designated by integer indices from 0 to `length - 1`. [cite: 363]

`ArrayType = ARRAY length {"," length} OF type.` [cite: 363]
`length = ConstExpression.` [cite: 363]

A declaration like `ARRAY N0, N1, ..., Nk OF T` is an abbreviation for: [cite: 363]
`ARRAY N0 OF`
`ARRAY N1 OF`
`...`
`ARRAY NK OF T`

Examples:
* `ARRAY N OF INTEGER` [cite: 363]
* `ARRAY 10, 20 OF REAL` [cite: 363]

### 6.3. Record Types
A record type is a structure with a fixed number of elements of possibly different types. [cite: 364] The record type declaration specifies the type and an identifier for each element, called a field. [cite: 364] The scope of these field identifiers is the record definition itself, and they are also visible within field designators (see 8.1) referring to elements of record variables. [cite: 364]

`RecordType = RECORD ["(" BaseType ")"] [FieldListSequence] END.` [cite: 364]
`BaseType = qualident.` [cite: 364]
`FieldListSequence = FieldList {";" FieldList}.` [cite: 365]
`FieldList = IdentList ":" type.` [cite: 365]
`IdentList = identdef {"," identdef}.` [cite: 365]

If a record type is exported, field identifiers intended for visibility outside the declaring module must be marked (public fields); unmarked fields are private. [cite: 366]

Record types are extensible; a record type can extend another. [cite: 367] For example, `CenterNode` directly extends `Node`, which is its direct base type. [cite: 368] `CenterNode` extends `Node` with the fields `name` and `subnode`. [cite: 369]
* **Definition**: A type `T` extends a type `T0` if `T` equals `T0`, or if `T` directly extends an extension of `T0`. [cite: 370]
* **Conversely**: A type `T0` is a base type of `T` if `T0` equals `T`, or if `T0` is the direct base type of a base type of `T`. [cite: 371]

Examples:
* `RECORD day, month, year: INTEGER END` [cite: 372]
* `RECORD name, firstname: ARRAY 32 OF CHAR; age: INTEGER; salary: REAL END` [cite: 372]

### 6.4. Pointer Types
Variables of a pointer type `P` hold values that point to variables of some type `T`. [cite: 372] `T` must be a record type. [cite: 372] `P` is bound to `T`, and `T` is the pointer base type of `P`. [cite: 373] Pointer types inherit the extension relation of their base types. [cite: 373] If `T` extends `T0`, and `P` is bound to `T`, then `P` is also an extension of `P0`, the pointer type bound to `T0`. [cite: 374]

`PointerType = POINTER TO type.` [cite: 375]

If `P` is defined as `POINTER TO T`, `T` can be declared textually after `P`, provided it is within the same scope. [cite: 375]
If `p` is a variable of type `P = POINTER TO T`, `NEW(p)` allocates a variable of type `T` in free storage and assigns a pointer to `p`. [cite: 376] This pointer `p` is of type `P`, and the referenced variable `p^` is of type `T`. [cite: 377] Allocation failure results in `p` being `NIL`. [cite: 377] Any pointer variable can be assigned `NIL`, which points to no variable. [cite: 378]

### 6.5. Procedure Types
Variables of a procedure type `T` can hold a procedure (or `NIL`) as a value. [cite: 379] If a procedure `P` is assigned to a procedure variable of type `T`, the formal parameter types of `P` must match those in `T`. [cite: 380] This also applies to the result type for function procedures (see 10.1). [cite: 380] `P` must not be declared local to another procedure, nor can it be a standard procedure. [cite: 381]

`ProcedureType = PROCEDURE [FormalParameters].` [cite: 382]

## 7. Variable Declarations
Variable declarations introduce variables and associate them with identifiers unique within their scope. [cite: 383] They also associate fixed data types with variables. [cite: 383]

`VariableDeclaration = IdentList ":" type.` [cite: 384]
Variables in the same list are of the same type. [cite: 384]
Examples (refer to examples in Ch. 6):

| | |
|---|---|
| `i, j, k:` | `INTEGER` [cite: 386] |
| `x, y:` | `REAL` [cite: 386] |
| `p, q:` | `BOOLEAN` [cite: 386] |
| `S:` | `SET` [cite: 386] |
| `f:` | `Function` [cite: 386] |
| `a:` | `ARRAY 100 OF REAL` [cite: 388] |
| `W:` | `ARRAY 16 OF RECORD ch: CHAR; count: INTEGER END` [cite: 388] |
| `t:` | `Tree` [cite: 388] |

## 8. Expressions
Expressions denote computation rules that combine constants and current variable values to derive other values using operators and function procedures. [cite: 389] Expressions consist of operands and operators. [cite: 390] Parentheses can be used to specify operator and operand associations. [cite: 390]

### 8.1. Operands
Except for sets and literal constants (numbers and strings), operands are denoted by designators. [cite: 391] A designator consists of an identifier referring to the constant, variable, or procedure. [cite: 392] This identifier can be qualified by module identifiers (see Ch. 4 and 11) and followed by selectors if the object is an element of a structure. [cite: 393]

* If `A` designates an array, `A[E]` denotes the element of `A` with index `E`. [cite: 394] `E` must be of type `INTEGER`. [cite: 394] `A[E1, E2, ..., En]` is equivalent to `A[E1][E2]...[En]`. [cite: 395]
* If `p` designates a pointer variable, `p^` denotes the variable referenced by `p`. [cite: 396]
* If `r` designates a record, `r.f` denotes field `f` of `r`. [cite: 397]
* If `p` designates a pointer, `p.f` denotes field `f` of the record `p^`; i.e., the dot implies dereferencing, and `p.f` stands for `p^.f`. [cite: 398]

The typeguard `V(T0)` asserts that `v` is of type `T0`, aborting execution if not. [cite: 398] The guard is applicable if:
1.  `T0` is an extension of `v`'s declared type `T`, and [cite: 399]
2.  `v` is a variable parameter of record type, or `v` is a pointer. [cite: 399]

`designator = qualident {selector}.` [cite: 400]
`selector = "." ident | "[" ExpList "]" | "^" | "(" qualident ")".` [cite: 400]
`ExpList = expression {"," expression}.` [cite: 401]

If the designated object is a variable, the designator refers to its current value. [cite: 401] If it's a procedure, a designator without a parameter list refers to the procedure itself. [cite: 402] If followed by a (possibly empty) parameter list, it implies procedure activation and stands for the result. [cite: 403] Actual parameter types must correspond to formal parameters in the procedure's declaration (see Ch. 10). [cite: 404]

Examples (refer to examples in Ch. 7):

| Designator | Type |
|---|---|
| `i` | `(INTEGER)` [cite: 406] |
| `a[i]` | `(REAL)` [cite: 406] |
| `w[3].ch` | `(CHAR)` [cite: 406] |
| `t.key` | `(INTEGER)` [cite: 406] |
| `t.left.right` | `(Tree)` [cite: 406] |
| `t(CenterNode).subnode` | `(Tree)` [cite: 406] |

### 8.2. Operators
Expression syntax distinguishes four operator classes with different precedences: `~` (highest), multiplication, addition, and relations. [cite: 407, 408] Operators of the same precedence associate from left to right; e.g., `x - y - z` means `(x - y) - z`. [cite: 409, 410]

`expression = SimpleExpression [relation SimpleExpression].` [cite: 410]
`relation = "=" | "#" | "<" | "<=" | ">" | ">=" | IN | IS.` [cite: 411]
`SimpleExpression = ["+" | "-"] term {AddOperator term}.` [cite: 412]
`AddOperator = "+" | "-" | OR.` [cite: 412]
`term = factor {MulOperator factor}.` [cite: 412]
`MulOperator = "*" | "/" | DIV | MOD | "&".` [cite: 413]
`factor = number | string | NIL | TRUE | FALSE | set | designator [ActualParameters] | "(" expression ")" | "~" factor.` [cite: 414]
`set = "{" [element {"," element}] "}".` [cite: 414]
`element = expression [".." expression].` [cite: 414]
`ActualParameters = "(" [ExpList] ")".` [cite: 415]

The set `{m..n}` denotes `{m, m+1, ..., n-1, n}`, and if `m > n`, it denotes the empty set. [cite: 415]
Some operators have multiple meanings; the actual operation is determined by operand types. [cite: 416, 417]

#### 8.2.1. Logical Operators
| Symbol | Result |
|---|---|
| `OR` | Logical disjunction [cite: 418] |
| `&` | Logical conjunction [cite: 418] |
| `~` | Negation [cite: 418] |

These operators apply to `BOOLEAN` operands and yield a `BOOLEAN` result. [cite: 419]
* `p OR q` stands for "if `p` then `TRUE`, else `q`" [cite: 420]
* `p & q` stands for "if `p` then `q`, else `FALSE`" [cite: 420]
* `~ p` stands for "not `p`" [cite: 420]

#### 8.2.2. Arithmetic Operators
| Symbol | Result |
|---|---|
| `+` | Sum [cite: 422] |
| `-` | Difference [cite: 422] |
| `*` | Product [cite: 422] |
| `/` | Quotient [cite: 422] |
| `DIV` | Integer quotient [cite: 422] |
| `MOD` | Modulus [cite: 422] |

The operators `+`, `-`, `*`, and `/` apply to numeric operands. [cite: 423] Both operands must be of the same type, which is also the result type. [cite: 424] As unary operators, `-` denotes sign inversion, and `+` denotes identity. [cite: 425]
`DIV` and `MOD` apply only to integer operands. [cite: 426] Given $q = x \text{ DIV } y$ and $r = x \text{ MOD } y$, quotient $q$ and remainder $r$ are defined by $x = q * y + r$, where $0 \le r < y$. [cite: 427, 429]

#### 8.2.3. Set Operators
| Symbol | Result |
|---|---|
| `+` | Union [cite: 428] |
| `-` | Difference [cite: 428] |
| `*` | Intersection [cite: 428] |
| `/` | Symmetric set difference [cite: 428] |

When used with a single `SET` operand, the minus sign denotes the set complement. [cite: 429]

#### 8.2.4. Relations
| Symbol | Relation |
|---|---|
| `=` | Equal [cite: 430] |
| `#` | Unequal [cite: 430] |
| `<` | Less [cite: 430] |
| `<=` | Less or equal [cite: 430] |
| `>` | Greater [cite: 430] |
| `>=` | Greater or equal [cite: 430] |
| `IN` | Set membership [cite: 430] |
| `IS` | Type test [cite: 430] |

Relations are Boolean. [cite: 431] Ordering relations `<`, `<=`, `>`, `>=` apply to numeric types, `CHAR`, and character arrays. [cite: 431] Relations `=` and `#` also apply to `BOOLEAN`, `SET`, and pointer and procedure types. [cite: 432]
* `x IN s` means "x is an element of s". [cite: 433] `x` must be `INTEGER`, and `s` must be `SET`. [cite: 434]
* `v IS T` means "v is of type T" and is a type test. [cite: 435] It is applicable if:
    1.  `T` is an extension of `v`'s declared type `T0`, and [cite: 436]
    2.  `v` is a variable parameter of record type or `v` is a pointer. [cite: 436]
For example, if `T` extends `T0` and `v` is declared of type `T0`, `v IS T` checks if the designated variable is also a `T`. [cite: 437] The value of `NIL IS T` is undefined. [cite: 437]

Examples (refer to examples in Ch. 7):

| Expression | Type |
|---|---|
| `1987` | `(INTEGER)` [cite: 439] |
| `i DIV 3` | `(INTEGER)` [cite: 439] |
| `~p OR q` | `(BOOLEAN)` [cite: 439] |
| `(i+j)*(i-j)` | `(INTEGER)` [cite: 439] |
| `s-{8,9,13}` | `(SET)` [cite: 439] |
| `a[i+j]*a[i-j]` | `(REAL)` [cite: 439] |
| `(0<=i) & (i<100)` | `(BOOLEAN)` [cite: 439] |
| `t.key=0` | `(BOOLEAN)` [cite: 439] |
| `k IN {i..j-1}` | `(BOOLEAN)` [cite: 439] |
| `t IS CenterNode` | `(BOOLEAN)` [cite: 439] |

## 9. Statements
Statements denote actions. [cite: 440]
* **Elementary statements** are not composed of other statements (assignment, procedure call). [cite: 441]
* **Structured statements** are composed of other statements (sequencing, conditional, selective, repetitive execution). [cite: 442, 443]
* An **empty statement** denotes no action and relaxes punctuation rules in statement sequences. [cite: 444, 445]

`statement = [assignment | ProcedureCall | IfStatement | CaseStatement | WhileStatement | RepeatStatement | ForStatement].` [cite: 446]

### 9.1. Assignments
The assignment replaces a variable's current value with a new one from an expression. [cite: 447] The assignment operator is `:=` and pronounced "becomes". [cite: 448]

`assignment = designator ":=" expression.` [cite: 448]
Assignments to structured value parameters (array or record type) or their elements are not permitted. [cite: 449] Assignments to imported variables are also not allowed. [cite: 450]
The expression type must match the designator's type, with the following exceptions: [cite: 451]
1.  `NIL` can be assigned to variables of any pointer or procedure type. [cite: 452]
2.  Strings can be assigned to character arrays if the string length is less than the array's length (a null character is appended). [cite: 453] Single-character strings can be assigned to `CHAR` variables. [cite: 454]
3.  For records, the source type must be an extension of the destination type. [cite: 455]
4.  An open array can be assigned to an array of the same base type. [cite: 456]

Examples (refer to examples in Ch. 7):
* `i := 0` [cite: 457]
* `p := i=j` [cite: 457]
* `x := FLT(i+1)` [cite: 457]
* `k := (i+j) DIV 2` [cite: 457]
* `f := log2` [cite: 457]
* `s := {2,3,5,7,11,13}` [cite: 457]
* `a[i] := (x+y)*(x-y)` [cite: 457]
* `t.key := i` [cite: 457]
* `w[i+1].ch := "A"` [cite: 457]

### 9.2. Procedure Calls
A procedure call activates a procedure. [cite: 458] It may contain actual parameters that substitute for formal parameters defined in the procedure declaration (see Ch. 10). [cite: 458] Correspondence is by parameter position. [cite: 459]
There are two kinds: variable and value parameters. [cite: 460]
* **Variable parameters**: The actual parameter must be a designator denoting a variable. [cite: 461] If it designates an element of a structured variable, the selector is evaluated before procedure execution. [cite: 462]
* **Value parameters**: The actual parameter must be an expression. [cite: 463] This expression is evaluated before activation, and the result is assigned to the formal parameter, which becomes a local variable (see 10.1). [cite: 464]

`ProcedureCall = designator [ActualParameters].` [cite: 465]
Examples:
* `ReadInt(i)` (see Ch. 10) [cite: 465]
* `WriteInt(2*j+1, 6)` [cite: 465]
* `INC(w[k].count)` [cite: 465]

### 9.3. Statement Sequences
Statement sequences denote a sequence of actions specified by component statements separated by semicolons. [cite: 466]
`StatementSequence = statement {";" statement}.` [cite: 467]

### 9.4. If Statements
If statements specify conditional execution of guarded statements. [cite: 468] The Boolean expression preceding a statement is its guard. [cite: 468] Guards are evaluated in order until one is `TRUE`, then its statement sequence is executed. [cite: 469] If no guard is satisfied, the `ELSE` statement sequence (if present) is executed. [cite: 470]

`IfStatement = IF expression THEN StatementSequence {ELSIF expression THEN StatementSequence} [ELSE StatementSequence] END.` [cite: 467]
Example:
```
IF ( (ch >= "A") & (ch <= "Z") ) THEN ReadIdentifier
 ELSIF (ch >= "0") & (ch <= "9") THEN ReadNumber
 ELSIF ch = 22X THEN ReadString
END
```
[cite: 471]

### 9.5. Case Statements
Case statements select and execute a statement sequence based on an expression's value. [cite: 472] The case expression is evaluated, and the statement sequence whose case label list contains the obtained value is executed. [cite: 472] If the case expression is `INTEGER` or `CHAR`, labels must be integers or single-character strings, respectively. [cite: 472]

`CaseStatement = CASE expression OF case {"|" case} END.` [cite: 472]
`case = [CaseLabelList ":" StatementSequence].` [cite: 472]
`CaseLabelList = LabelRange {"," LabelRange}.` [cite: 472]
`LabelRange = label [".." label].` [cite: 472]
`label = integer | string | qualident.` [cite: 472]
Example:
```
CASE K OF
 0: x := x + y
 | 1: x := x - y
 | 2: x := x * y
 | 3: x := x / y
END
```
[cite: 472]
The type `T` of the case expression (case variable) can also be a record or pointer type. [cite: 473] In this situation, the case labels must be extensions of `T`, and in the statements `Si` labeled by `Ti`, the case variable is considered of type `Ti`. [cite: 473]

Example:
```
TYPE R = RECORD a: INTEGER END;
 R0 = RECORD (R) b: INTEGER END;
 R1 = RECORD (R) b: REAL END;
 R2 = RECORD (R) b: SET END;

P = POINTER TO R;
P0 = POINTER TO R0;
P1 = POINTER TO R1;
P2 = POINTER TO R2;

VAR p: P;

CASE p OF
 P0: p.b := 10
 | P1: p.b := 2.5
 | P2: p.b := {0,2}
END
```
[cite: 474, 475, 476]

### 9.6. While Statements
While statements specify repetition. [cite: 477] If any Boolean expression (guard) is `TRUE`, the corresponding statement sequence is executed. [cite: 477] This evaluation and execution repeat until no Boolean expression yields `TRUE`. [cite: 478]

`WhileStatement = WHILE expression DO StatementSequence {ELSIF expression DO StatementSequence} END.` [cite: 479]
Examples:
```
WHILE j > 0 DO
 j := j DIV 2;
 i := i+1
END
```
[cite: 480, 481]
```
WHILE (t # NIL) & (t.key # i) DO
 t := t.left
END
```
[cite: 481]
```
WHILE m > n DO m := m – n
ELSIF n > m DO n := n – m
END
```
[cite: 481]

### 9.7. Repeat Statements
A repeat statement specifies repeated execution of a statement sequence until a condition is satisfied. [cite: 482] The statement sequence executes at least once. [cite: 483]

`RepeatStatement = REPEAT StatementSequence UNTIL expression.` [cite: 483]

### 9.8. For Statements
A for statement specifies repeated execution of a statement sequence for a given number of times, assigning a progression of values to an integer control variable. [cite: 484, 485]

`ForStatement = FOR ident ":=" expression TO expression [BY ConstExpression] DO StatementSequence END.` [cite: 485]
The statement `FOR v := beg TO end BY inc DO S END` is equivalent to: [cite: 486]
* If `inc > 0`: `v := beg; WHILE v <= end DO S; v := v + inc END` [cite: 487]
* If `inc < 0`: `v := beg; WHILE v >= end DO S; v := v + inc END` [cite: 488]
The types of `v`, `beg`, and `end` must be `INTEGER`, and `inc` must be an integer constant expression. [cite: 488] If `BY` is not specified, `inc` defaults to 1. [cite: 489]

## 10. Procedure Declarations
Procedure declarations consist of a procedure heading and a procedure body. [cite: 490] The heading specifies the procedure identifier, formal parameters, and result type (if any). [cite: 490] The body contains declarations and statements. [cite: 491] The procedure identifier is repeated at the end of the declaration. [cite: 491]

There are two kinds of procedures: proper procedures and function procedures. [cite: 492]
* **Function procedures** are activated by a function designator within an expression and yield a result that is an operand in the expression. [cite: 493, 494] They are distinguished by indicating their result type after the parameter list in their declaration. [cite: 495] Their body must end with a `RETURN` clause defining the result. [cite: 496]
* **Proper procedures** are activated by a procedure call. [cite: 494]

All constants, variables, types, and procedures declared within a procedure body are local to the procedure. [cite: 497] Local variable values are undefined upon entry. [cite: 498] Procedures can be nested as they can be declared as local objects. [cite: 499] Objects declared globally are also visible within the procedure, in addition to its formal parameters and locally declared objects. [cite: 500] Using the procedure identifier in a call within its declaration implies recursive activation. [cite: 501]

`ProcedureDeclaration = ProcedureHeading ";" ProcedureBody ident.` [cite: 502]
`ProcedureHeading = PROCEDURE identdef [FormalParameters].` [cite: 502]
`ProcedureBody = DeclarationSequence [BEGIN StatementSequence] [RETURN expression] END.` [cite: 502]
`DeclarationSequence = [CONST {ConstDeclaration ";"}] [TYPE {TypeDeclaration ";"}] [VAR {VariableDeclaration ";"}] {ProcedureDeclaration ";"}.` [cite: 503]

### 10.1. Formal Parameters
Formal parameters are identifiers that denote actual parameters specified in a procedure call. [cite: 504] Their correspondence is established when the procedure is called. [cite: 505] There are two kinds: value and variable parameters. [cite: 506]
* A **variable parameter** corresponds to an actual parameter that is a variable, and it stands for that variable. [cite: 507]
* A **value parameter** corresponds to an actual parameter that is an expression, and it stands for its value, which cannot be changed by assignment. [cite: 508] If a value parameter is of a basic type, it represents a local variable initialized with the actual expression's value. [cite: 509]

Variable parameters are denoted by `VAR`; value parameters have no prefix. [cite: 510]
A parameterless function procedure must have an empty parameter list and be called by a function designator with an empty actual parameter list. [cite: 511, 512]
Formal parameters are local to the procedure; their scope is the procedure declaration text. [cite: 513]

`FormalParameters = "(" [FPSection {";" FPSection}] ")" [":" qualident].` [cite: 514]
`FPSection = [VAR] ident {"," ident} ":" FormalType.` [cite: 514]
`FormalType = {ARRAY OF} qualident.` [cite: 515]

The type of each formal parameter is specified in the parameter list. [cite: 515] For variable parameters, it must be identical to the corresponding actual parameter's type, except for records, where it must be a base type of the actual parameter's type. [cite: 516]
If the formal parameter's type is `ARRAY OF T`, it is an open array, and the corresponding actual parameter can be of arbitrary length. [cite: 517]
If a formal parameter specifies a procedure type, the actual parameter must be either a globally declared procedure or a variable (or parameter) of that procedure type. [cite: 518] It cannot be a predefined procedure. [cite: 519] The result type of a procedure cannot be a record or an array. [cite: 519]

Examples:
```
PROCEDURE ReadInt(VAR x: INTEGER);
 VAR i : INTEGER; ch: CHAR;
BEGIN i := 0; Read(ch);
 WHILE ("0" <= ch) & (ch <= "9") DO
 i := 10*i + (ORD(ch)-ORD("0")); Read(ch)
 END ;
 x := i
END ReadInt
```
[cite: 521, 522, 523]
```
PROCEDURE WriteInt(x: INTEGER); (* 0 <= x < 10^5 *)
 VAR i: INTEGER; buf: ARRAY 5 OF INTEGER;
BEGIN i := 0;
 REPEAT buf[i] := x MOD 10; x := x DIV 10;
 INC(i) UNTIL x = 0;
 REPEAT DEC(i); Write(CHR(buf[i] + ORD("0"))) UNTIL i = 0
END WriteInt
```
[cite: 523, 524, 525]
```
PROCEDURE log2(x: INTEGER): INTEGER;
 VAR y: INTEGER; (*assume x>0*)
BEGIN y := 0;
 WHILE x > 1 DO x := x DIV 2;
 INC(y) END ;
 RETURN y
END log2
```
[cite: 526, 527]

### 10.2. Predefined Procedures
The following table lists predefined procedures. [cite: 528] Some are generic, applying to several operand types. [cite: 528] `v` stands for a variable, `x` and `n` for expressions, and `T` for a type. [cite: 529]

**Function procedures:** [cite: 530]

| Name | Argument type | Result type | Function |
|---|---|---|---|
| `ABS(x)` | `x: numeric type` | `type of x` | Absolute value [cite: 530] |
| `ODD(x)` | `x: INTEGER` | `BOOLEAN` | `x MOD 2 = 1` [cite: 530] |
| `LEN(v)` | `v: array` | `INTEGER` | The length of `v` [cite: 530] |
| `LSL(x, n)` | `x, n: INTEGER` | `INTEGER` | Logical shift left, $x * 2^n$ [cite: 530] |
| `ASR(x, n)` | `x, n: INTEGER` | `INTEGER` | Signed shift right, $x \text{ DIV } 2^n$ [cite: 530] |
| `ROR(x, n)` | `x, n: INTEGER` | `INTEGER` | `x` rotated right by `n` bits [cite: 530] |

**Type conversion functions:** [cite: 530]

| Name | Argument type | Result type | Function |
|---|---|---|---|
| `FLOOR(x)` | `REAL` | `INTEGER` | Round down [cite: 530] |
| `FLT(x)` | `INTEGER` | `REAL` | Identity [cite: 530] |
| `ORD(x)` | `CHAR, BOOLEAN, SET` | `INTEGER` | Ordinal number of `x` [cite: 530] |
| `CHR(x)` | `INTEGER` | `CHAR` | Character with ordinal number `x` [cite: 531] |

**Proper procedures:** [cite: 531]

| Name | Argument types | Function |
|---|---|---|
| `INC(v)` | `INTEGER` | `v := v + 1` [cite: 531] |
| `INC(v, n)` | `INTEGER` | `v := v + n` [cite: 531] |
| `DEC(v)` | `INTEGER` | `v := v - 1` [cite: 531] |
| `DEC(v, n)` | `INTEGER` | `v := v - n` [cite: 531] |
| `INCL(v, x)` | `v: SET; x: INTEGER` | `v := v + {x}` [cite: 532] |
| `EXCL(v, x)` | `v: SET; x: INTEGER` | `v := v - {x}` [cite: 532] |
| `NEW(v)` | `pointer type` | Allocate `v^` [cite: 533] |
| `ASSERT(b)` | `BOOLEAN` | Abort, if `~b` [cite: 533] |
| `PACK(x, n)` | `REAL; INTEGER` | Pack `x` and `n` into `x` [cite: 534] |
| `UNPK(x, n)` | `REAL; INTEGER` | Unpack `x` into `x` and `n` [cite: 535] |

`FLOOR(x)` yields the largest integer not greater than `x`. [cite: 535] E.g., `FLOOR(1.5) = 1`, `FLOOR(-1.5) = -2`. [cite: 536]
The parameter `n` of `PACK` represents the exponent of `x`. [cite: 536] `PACK(x, y)` is equivalent to `x := x * 2^y`. [cite: 537] `UNPK` is the reverse operation; the resulting `x` is normalized such that $1.0 \le x < 2.0$. [cite: 538]

## 11. Modules
A module is a collection of declarations for constants, types, variables, and procedures, along with a statement sequence for variable initialization. [cite: 539] A module typically forms a compilable unit. [cite: 540]

`module = MODULE ident ";" [ImportList] DeclarationSequence [BEGIN StatementSequence] END ident "." .` [cite: 541]
`ImportList = IMPORT import {"," import} ";" .` [cite: 542]
`import = ident [":=" ident].` [cite: 542]

The import list specifies client modules. [cite: 543] If identifier `x` is exported from module `M` and `M` is in the import list, `x` is referenced as `M.x`. [cite: 543] If `M := M1` is used in the import list, an exported object `x` from `M1` is referenced as `M.x` in the importing module. [cite: 544]
Identifiers to be visible in client modules (exported) must be marked with an asterisk (`*`) in their declaration. [cite: 545] Variables are always exported in read-only mode. [cite: 546]
The statement sequence after `BEGIN` executes when the module is loaded. [cite: 546] Afterward, individual (parameterless) procedures can be activated as commands from the system. [cite: 547]

Example:
```
MODULE Out; (*exported procedures: Write, WriteInt, WriteLn*)
 IMPORT Texts, Oberon;
 VAR W: Texts.Writer;
 PROCEDURE Write*(ch: CHAR);
BEGIN Texts.Write(W, ch)
 END ;
 PROCEDURE WriteInt*(x, n: INTEGER);
 VAR i: INTEGER; a: ARRAY 16 OF CHAR;
BEGIN i := 0;
 IF x < 0 THEN Texts.Write(W, "-"); x := -x END ;
 REPEAT a[i] := CHR(x MOD 10 + ORD("0")); x := x DIV 10; INC(i) UNTIL x = 0;
 REPEAT Texts.Write(W, " "); DEC(n) UNTIL n <= i;
 REPEAT DEC(i); Texts.Write(W, a[i]) UNTIL i = 0
 END WriteInt;
 PROCEDURE WriteLn*;
 BEGIN Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
 END WriteLn;
BEGIN Texts.OpenWriter(W)
END Out.
```
[cite: 548, 549, 550, 551, 552, 553]

### 11.1 The Module SYSTEM
The optional `SYSTEM` module defines low-level operations directly accessing computer- and implementation-specific resources, such as device access and bypassing data type compatibility rules. [cite: 554, 555]
`SYSTEM` facilities are provided for two reasons:
1.  Their values are implementation-dependent and not derivable from the language definition. [cite: 557]
2.  They can corrupt a system (e.g., `PUT`). [cite: 557]
Their use is strongly recommended to be restricted to specific low-level modules, as such modules are non-portable and not "type-safe". [cite: 558] They are easily recognized by the `SYSTEM` identifier in the module's import lists. [cite: 559] The following definitions are generally applicable; individual implementations may include additional definitions specific to their underlying computer. [cite: 560]
In the following, `v` stands for a variable, and `x`, `a`, and `n` for expressions. [cite: 561]

**Function procedures:** [cite: 562]

| Name | Argument types | Result type | Function |
|---|---|---|---|
| `ADR(v)` | `any` | `INTEGER` | Address of variable `v` [cite: 562] |
| `SIZE(T)` | `any type` | `INTEGER` | Size in bytes [cite: 562] |
| `BIT(a, n)` | `a, n: INTEGER` | `BOOLEAN` | Bit `n` of `mem[a]` [cite: 562] |

**Proper procedures:** [cite: 563]

| Name | Argument types | Function |
|---|---|---|
| `GET(a, v)` | `a: INTEGER; v: any basic type` | `v := mem[a]` [cite: 563] |
| `PUT(a, x)` | `a: INTEGER; x: any basic type` | `mem[a] := x` [cite: 564] |
| `COPY(src, dst, n)` | `all INTEGER` | Copy `n` consecutive words from `src` to `dst` [cite: 564] |

The following are additional procedures accepted by the compiler for the RISC processor: [cite: 564]

**Function procedures:** [cite: 565]

| Name | Argument types | Result type | Function |
|---|---|---|---|
| `VAL(T, n)` | `scalar` | `T` | Identity [cite: 565] |
| `ADC(m, n)` | `INTEGER` | `INTEGER` | Add with carry C [cite: 565] |
| `SBC(m, n)` | `INTEGER` | `INTEGER` | Subtract with carry C [cite: 565] |
| `UML(m, n)` | `INTEGER` | `INTEGER` | Unsigned multiplication [cite: 565] |
| `COND(n)` | `INTEGER` | `BOOLEAN` | `IF Cond(n) THEN ...` [cite: 565] |

**Proper procedures:** [cite: 565]

| Name | Argument types | Function |
|---|---|---|
| `LED(n)` | `INTEGER` | Display `n` on LEDs [cite: 565] |

## Appendix: The Syntax of Oberon
* `letter = "A" | "B" | … | "Z" | "a" | "b" | … | "z".` [cite: 565, 566]
* `digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9".` [cite: 566, 567]
* `hexDigit = digit | "A" | "B" | "C" | "D" | "E" | "F".` [cite: 567, 568]
* `ident = letter {letter | digit}.` [cite: 568]
* `qualident = [ident "."] ident.` [cite: 568]
* `identdef = ident ["*"].` [cite: 569]
* `integer = digit {digit} | digit {hexDigit} "H".` [cite: 569]
* `real = digit {digit} "." {digit} [ScaleFactor].` [cite: 569]
* `ScaleFactor = "E" ["+" | "-"] digit {digit}.` [cite: 570]
* `number = integer | real.` [cite: 570]
* `string = """ {character} """ | digit {hexDigit} "X".` [cite: 570]
* `ConstDeclaration = identdef "=" ConstExpression.` [cite: 571]
* `ConstExpression = expression.` [cite: 571]
* `TypeDeclaration = identdef "=" type.` [cite: 571]
* `type = qualident | ArrayType | RecordType | PointerType | ProcedureType.` [cite: 572]
* `ArrayType = ARRAY length {"," length} OF type.` [cite: 572]
* `length = ConstExpression.` [cite: 572]
* `RecordType = RECORD ["(" BaseType ")"] [FieldListSequence] END.` [cite: 573]
* `BaseType = qualident.` [cite: 573]
* `FieldListSequence = FieldList {";" FieldList}.` [cite: 573]
* `FieldList = IdentList ":" type.` [cite: 573]
* `IdentList = identdef {"," identdef}.` [cite: 574]
* `PointerType = POINTER TO type.` [cite: 574]
* `ProcedureType = PROCEDURE [FormalParameters].` [cite: 574]
* `VariableDeclaration = IdentList ":" type.` [cite: 575]
* `expression = SimpleExpression [relation SimpleExpression].` [cite: 575]
* `relation = "=" | "#" | "<" | "<=" | ">" | ">=" | IN | IS.` [cite: 576]
* `SimpleExpression = ["+" | "-"] term {AddOperator term}.` [cite: 576]
* `AddOperator = "+" | "-" | OR.` [cite: 576]
* `term = factor {MulOperator factor}.` [cite: 577]
* `MulOperator = "*" | "/" | DIV | MOD | "&".` [cite: 577]
* `factor = number | string | NIL | TRUE | FALSE | set | designator [ActualParameters] | "(" expression ")" | "~" factor.` [cite: 578]
* `designator = qualident {selector}.` [cite: 579]
* `selector = "." ident | "[" ExpList "]" | "^" | "(" qualident ")".` [cite: 579]
* `set = "{" [element {"," element}] "}".` [cite: 580]
* `element = expression [".." expression].` [cite: 580]
* `ExpList = expression {"," expression}.` [cite: 581]
* `ActualParameters = "(" [ExpList] ")".` [cite: 581]
* `statement = [assignment | ProcedureCall | IfStatement | CaseStatement | WhileStatement | RepeatStatement | ForStatement].` [cite: 582]
* `assignment = designator ":=" expression.` [cite: 582]
* `ProcedureCall = designator [ActualParameters].` [cite: 582]
* `StatementSequence = statement {";" statement}.` [cite: 583]
* `IfStatement = IF expression THEN StatementSequence {ELSIF expression THEN StatementSequence} [ELSE StatementSequence] END.` [cite: 583]
* `CaseStatement = CASE expression OF case {"|" case} END.` [cite: 584]
* `case = [CaseLabelList ":" StatementSequence].` [cite: 584]
* `CaseLabelList = LabelRange {"," LabelRange}.` [cite: 585]
* `LabelRange = label [".." label].` [cite: 585]
* `label = integer | string | qualident.` [cite: 586]
* `WhileStatement = WHILE expression DO StatementSequence {ELSIF expression DO StatementSequence} END.` [cite: 586]
* `RepeatStatement = REPEAT StatementSequence UNTIL expression.` [cite: 587]
* `ForStatement = FOR ident ":=" expression TO expression [BY ConstExpression] DO StatementSequence END.` [cite: 587]
* `ProcedureDeclaration = ProcedureHeading ";" ProcedureBody ident.` [cite: 588]
* `ProcedureHeading = PROCEDURE identdef [FormalParameters].` [cite: 588]
* `ProcedureBody = DeclarationSequence [BEGIN StatementSequence] [RETURN expression] END.` [cite: 589]
* `DeclarationSequence = [CONST {ConstDeclaration ";"}] [TYPE {TypeDeclaration ";"}] [VAR {VariableDeclaration ";"}] {ProcedureDeclaration ";"}.` [cite: 589, 590]
* `FormalParameters = "(" [FPSection {";" FPSection}] ")" [":" qualident].` [cite: 590]
* `FPSection = [VAR] ident {"," ident} ":" FormalType.` [cite: 591]
* `FormalType = {ARRAY OF} qualident.` [cite: 591]
* `module = MODULE ident ";" [ImportList] DeclarationSequence [BEGIN StatementSequence] END ident "." .` [cite: 591]
* `ImportList = IMPORT import {"," import} ";".` [cite: 592]
* `import = ident [":=" ident].` [cite: 592]