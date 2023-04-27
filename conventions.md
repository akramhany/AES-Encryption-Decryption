# 👨‍🚒 Team Conventions

## 🖊️ Naming Conventions

- Input and Output ports should be prefixed with `i_` and `o_` 
```Verilog
module AmazingModule (
  i_clk,
  i_data,
  i_en,
  o_flag,
  o_data
) 
  // Module Code
endmodule
```
- Internal signals should be written in `CamelCase`
```Verilog

module AmazingModule (
  i_clk,
  i_data,
  i_en,
  o_flag,
  o_data
) 
  wire [7:0] internalSignal;
  wire [7:0] someOtherInternalSignal;
  // Module Code
endmodule