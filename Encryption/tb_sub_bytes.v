`include "sub_bytes.v"

module tb_sub_bytes();

//inputs
reg [127:0]  test_case;
//outputs
wire [127:0] result;

// unit under test
sub_bytes uut(
    .i_initial_state(test_case),
    .o_result_state(result)
);

initial begin
    test_case = 128'd0;
    #100;

    //test case 0
    test_case = 128'h00102030405060708090a0b0c0d0e0f0;
    #10;
    $display("Test Case: 0");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'h63cab7040953d051cd60e0e7ba70e18c);
    $display("Got:                    %h", result);

    if (result != 128'h63cab7040953d051cd60e0e7ba70e18c) begin
          $display("Testcase 0 failed");
        end
    else begin
        $display("Testcase 0 passed");
    end
    
    $display("=======================================================");

    #100;
    //test case 1
    test_case = 128'h89d810e8855ace682d1843d8cb128fe4;
    #10;
    $display("Test Case: 1");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'ha761ca9b97be8b45d8ad1a611fc97369);
    $display("Got:                    %h", result);

    if (result != 128'ha761ca9b97be8b45d8ad1a611fc97369) begin
          $display("Testcase 1 failed");
        end
    else begin
        $display("Testcase 1 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 2
    test_case = 128'hc81677bc9b7ac93b25027992b0261996;
    #10;
    $display("Test Case: 2");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'he847f56514dadde23f77b64fe7f7d490);
    $display("Got:                    %h", result);

    if (result != 128'he847f56514dadde23f77b64fe7f7d490) begin
          $display("Testcase 2 failed");
        end
    else begin
        $display("Testcase 2 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 3
    test_case = 128'h4915598f55e5d7a0daca94fa1f0a63f7;
    #10;
    $display("Test Case: 3");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'h3b59cb73fcd90ee05774222dc067fb68);
    $display("Got:                    %h", result);

    if (result != 128'h3b59cb73fcd90ee05774222dc067fb68) begin
          $display("Testcase 3 failed");
        end
    else begin
        $display("Testcase 3 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 4
    test_case = 128'hfa636a2825b339c940668a3157244d17;
    #10;
    $display("Test Case: 4");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'h2dfb02343f6d12dd09337ec75b36e3f0);
    $display("Got:                    %h", result);

    if (result != 128'h2dfb02343f6d12dd09337ec75b36e3f0) begin
          $display("Testcase 4 failed");
        end
    else begin
        $display("Testcase 4 passed");
    end

    $display("=======================================================");
    
    #100;
    //test case 5
    test_case = 128'h247240236966b3fa6ed2753288425b6c;
    #10;
    $display("Test Case: 5");
    $display("Input:                  %h", test_case);
    $display("Expected Output:        %h", 128'h36400926f9336d2d9fb59d23c42c3950);
    $display("Got:                    %h", result);

    if (result != 128'h36400926f9336d2d9fb59d23c42c3950) begin
          $display("Testcase 5 failed");
        end
    else begin
        $display("Testcase 5 passed");
    end

    #10 $finish;
end

endmodule