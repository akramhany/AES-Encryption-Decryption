# 👨‍🚒 Team Conventions

## 🖊️ Naming Conventions

Some Naming Conventions to be followed while writing code.

Definitions:
1. `PascalCase` - First letter of each word is capitalized
2. `CamelCase`  - First letter of each word is capitalized except the first word
3. `UPPER_CASE` - All letters are capitalized and words are separated by `_`
4. `lower_case` - All letters are lower case and words are separated by `_`


### File Names
File names should be written in `lower_case` and should be descriptive of the contents of the file.
```Verilog
aes.v
mix_columns.v
input_message_buffer.v
```

### Module Names
Module names should be written in `lower_case` and should be descriptive of the contents of the module.
```Verilog
module mix_columns;
module input_message_buffer;
module aes;
```

### Variables

- Variables should be written in `lower_case`
```Verilog

module amazing_module (
  i_clk,
  i_data,
  i_en,
  o_flag,
  o_data
) 
  reg [7:0] data;
  reg [7:0] data_out;
  // amazing stuff
endmodule
```

- Input and Output ports should be prefixed with `i_` and `o_` 
```Verilog
module amazing_module (
  i_clk,
  i_data,
  i_en,
  o_flag,
  o_data
) 
  // amazing stuff
endmodule
```

- Constants should be written in `UPPER_CASE`
```Verilog
module amazing_module (
  i_clk,
  i_data,
  i_en,
  o_flag,
  o_data
) 
  localparam WIDTH = 8;
  localparam MAX = 255;
  // amazing stuff
endmodule
```

- Abbreviations used in a module must be documented and uncommon abbreviations should be avoided.

## 🦴 Code Layout
### Indentation
Use 4 spaces for indentation

### `begin` and `end`
- `begin` goes on the same line as the first statement of the block it belongs to
- `end` goes on a new line

```Verilog
always @(posedge i_clk) begin
  if (i_en) begin
    data <= i_data;
  end
end
```

### `if` and `else`
- `else` starts a new line
```Verilog
if (i_en) begin
  data <= i_data;
end 
else begin
  data <= 0;
end
```
- always use `begin` and `end` even if there is only one statement in the block
```Verilog
if (i_en) begin
  data <= i_data;
end 
else begin
  data <= 0;
end
```

## 📝 Comments
### Docstring
- Every module should have a docstring (a comment describing the module)
- provides a high level description of what the code in that file does

```Verilog

/*
  *
  * Module: amazing_module
  * Description: This module does amazing stuff
  * 
  * Inputs:
  *   i_clk: clock
  *   i_data: data
  *   i_en: enable
  * Outputs:
  *   o_flag: flag
  *   o_data: data
  *
  * Author: Amazing Author
  * Date: 18/4/2003
*/

```


## 🖊️ For More Read this guide line:
[📖 Verilog Style Guide](https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md)

## 🔥 Coding Conventions
- For state Matrix, we use this convention:
![STATE MATRIX](imgs/state_matrix.png)
- for this declration:
![STATE DECLARATIONS](imgs/state_declration.png)