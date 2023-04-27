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