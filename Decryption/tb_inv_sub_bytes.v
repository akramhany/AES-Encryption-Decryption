`include "inv_sub_bytes.v"

module tb_inv_sub_bytes();

//inputs
reg [127:0]  test_case;
//outputs
wire [127:0] result;

// unit under test
inv_sub_bytes uut(
    .i_initial_state(test_case),
    .o_result_state(result)
);

initial begin
    test_case = 128'd0;
    #100;

    //test case 0
    test_case = 128'h7ad5fda789ef4e272bca100b3d9ff59f;
    #10;
    $display("Test Case: 0");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'hbdb52189f261b63d0b107c9e8b6e776e);
    $display("Got:                    %h", result);

    if (result != 128'hbdb52189f261b63d0b107c9e8b6e776e) begin
          $display("Testcase 0 failed");
        end
    else begin
        $display("Testcase 0 passed");
    end
    
    $display("=======================================================");

    #100;
    //test case 1
    test_case = 128'h54d990a16ba09ab596bbf40ea111702f;
    #10;
    $display("Test Case: 1");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'hfde596f1054737d235febad7f1e3d04e);
    $display("Got:                    %h", result);

    if (result != 128'hfde596f1054737d235febad7f1e3d04e) begin
          $display("Testcase 1 failed");
        end
    else begin
        $display("Testcase 1 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 2
    test_case = 128'h3e1c22c0b6fcbf768da85067f6170495;
    #10;
    $display("Test Case: 2");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'hd1c4941f7955f40fb46f6c0ad68730ad);
    $display("Got:                    %h", result);

    if (result != 128'hd1c4941f7955f40fb46f6c0ad68730ad) begin
          $display("Testcase 2 failed");
        end
    else begin
        $display("Testcase 2 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 3
    test_case = 128'hb458124c68b68a014b99f82e5f15554c;
    #10;
    $display("Test Case: 3");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'hc65e395df779cf09ccf9e1c3842fed5d);
    $display("Got:                    %h", result);

    if (result != 128'hc65e395df779cf09ccf9e1c3842fed5d) begin
          $display("Testcase 3 failed");
        end
    else begin
        $display("Testcase 3 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 4
    test_case = 128'he8dab6901477d4653ff7f5e2e747dd4f;
    #10;
    $display("Test Case: 4");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'hc87a79969b0219bc2526773bb016c992);
    $display("Got:                    %h", result);

    if (result != 128'hc87a79969b0219bc2526773bb016c992) begin
          $display("Testcase 4 failed");
        end
    else begin
        $display("Testcase 4 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 5
    test_case = 128'h36339d50f9b539269f2c092dc4406d23;
    #10;
    $display("Test Case: 5");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'h2466756c69d25b236e4240fa8872b332);
    $display("Got:                    %h", result);

    if (result != 128'h2466756c69d25b236e4240fa8872b332) begin
          $display("Testcase 5 failed");
        end
    else begin
        $display("Testcase 5 passed");
    end

    #10 $finish;
end

endmodule