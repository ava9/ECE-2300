/*  lab4_test.v
    ECE/ENGRD 2300, Spring 2014

    Author: Saugata Ghose
    Last modified: March 19, 2014

    Description: Skeleton test bench for Part B of reaction time game circuit.
*/

// sets the granularity at which we simulate
`timescale 1 ns / 1 ps


// name of the top-level module; for us it should always be <module name>_test
// this top-level module should have no inputs or outputs; only internal signals are needed
module lab4_test();

  // for all of your input pins, declare them as type reg, and name them identically to the pins
  reg        CLK50;
  reg        RESET;
  reg  [2:0] CLK_SEL;
  reg        NEXT;
  reg        PLAYER_A;
  reg        PLAYER_B;
  reg        TEST_LOAD;

  // for all of your output pins, declare them as type wire so ModelSim can display them
  wire       CLK;
  wire       SIGNAL;
  wire [3:0] SCORE_A;
  wire [3:0] SCORE_B;
  wire [3:0] WINNER;
  wire [3:0] STATE;
  wire       FALSE_START;
  wire [2:0] ADDRESS;
  wire [9:0] DATA;

  // variables - internal state that can be used for statistics such as
  //   counters, but are not visible outside the test bench
  integer currentTestCorrect;
  integer numTestsPassed;
  integer currentLoopFailed;
  integer i;
  integer previousState;


  // declare a sub-circuit instance (Unit Under Test) of the circuit that you designed
  // make sure to include all ports you want to see, and connect them to the variables above
  lab4 UUT(
    .CLK50(CLK50),
    .RESET(RESET),
    .CLK_SEL(CLK_SEL),
    .CLK(CLK),
    .NEXT(NEXT),
    .PLAYER_A(PLAYER_A),
    .PLAYER_B(PLAYER_B),
    .TEST_LOAD(TEST_LOAD),
    .SIGNAL(SIGNAL),
    .SCORE_A(SCORE_A),
    .SCORE_B(SCORE_B),
    .WINNER(WINNER),
    .STATE(STATE),
    .FALSE_START(FALSE_START),
    .ADDRESS(ADDRESS),
    .DATA(DATA) // remember - no comma after the last port
  );

  // ALL of the initial and always blocks below will work in parallel.
  //   Starting at time t = 0, they will all start counting the number
  //   of ticks.


  // CLK50: generate a 50 MHz clock (rising edge does not start until
  //   10 ticks (10 ns) into simulation, and each clock cycle lasts for
  //   20 ticks (20 ns)
  initial begin
    CLK50 = 1'b0;
    forever begin
      #10
      CLK50 = ~CLK50;
    end
  end


  // CLK_SEL: choose simulation mode
  // Remember that for simulation we will use 3'b111 (10MHz), but that
  // for demoing on the FPGA, we will use 3'b010 (100Hz)
  initial
  begin
    CLK_SEL = 3'b111;
  end


  // TEST CASES: add your test cases in the block here
  // REMEMBER: separate each test case by delays that are multiples of #100, so we can see
  //    the output for at least one cycle (since we chose a 10 MHz clock)
  initial
  begin
    // Initial values
    RESET    = 1'b0;
    NEXT     = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;

    // wait at the beginning to make sure that we don't start on a rising clock edge -
    //    this guarantees that we give the flip-flops enough setup time
    #50;

    // start TEST CASES here






    $display("MSIM>");
    $display("MSIM> ===============================================================");
    $display("MSIM>");
    $display("MSIM> PART B LAB TEST CASES (can be ignored for Part B prelab)");
    $display("MSIM>");
    $display("MSIM> ===============================================================");
    $display("MSIM>");


    currentTestCorrect = 1;
    numTestsPassed = 0;


    $display("MSIM> ");
    $display("MSIM> TEST 1: TWO REGULAR WINS");
    $display("MSIM> ========================");
    $display("MSIM> ");


    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 0: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 1: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 200 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 200; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 2: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 200-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 3: Error with signaling after 200-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 4: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 10 cycles to skip to just after end of false start period...");

    #1000;  // wait ten cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A when button pressed after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 5: Error with giving point to Player A when button pressed after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b000) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 6: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd700 && ADDRESS == 3'b001) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 7: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 700 (ADDRESS = %3b, should be 001). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd350 && ADDRESS == 3'b010) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 8: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 350 (ADDRESS = %3b, should be 010). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 9: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 350 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 350; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 10: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end
      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 350-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 11: Error with signaling after 350-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 12: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 9 cycles to skip to just before end of false start period...");

    #900;  // wait nine cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'b0 && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player B when Player A false starts. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 13: Error with giving point to Player B when Player A false starts. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 14: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player B false starting immediately
    PLAYER_B = 1'b0;

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A when Player B false starts while beginning to count down. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 15: Error with giving point to Player A when Player B false starts while beginning to count down. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd350 && ADDRESS == 3'b010) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 16: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 350 (ADDRESS = %3b, should be 010). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player B releasing button
    PLAYER_B = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd500 && ADDRESS == 3'b011) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> ERROR 17: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 500 (ADDRESS = %3b, should be 011). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 18: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 500 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 500; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 19: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 500-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 20: Error with signaling after 500-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 21: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 25 cycles to skip false start period...");

    #2500;  // wait 25 cycles

    // simulate Player B reacting immediately
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player B when button pressed after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 22: Error with giving point to Player B when button pressed after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player B releasing button
    PLAYER_B = 1'b1;

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd150 && ADDRESS == 3'b110) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 23: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 150 (ADDRESS = %3b, should be 110). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 24: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 150 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 150; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b1 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 25: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 150-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 26: Error with signaling after 150-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 27: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 12 cycles to skip false start period...");

    #1200;  // wait twelve cycles

    // simulate Player B reacting immediately
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b10 && WINNER == 4'hb && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player B when button pressed after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 28: Error with giving point/win to Player B when button pressed after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 2), WINNER = %1h (exp. b), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b10 && WINNER == 4'hb && FALSE_START == 1'b0 && DATA == 10'd150 && ADDRESS == 3'b110) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of game is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 29: Waiting after end of game is incorrect. DATA from prandom is %3d, should be 150 (ADDRESS = %3b, should be 110). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 2), WINNER = %1h (exp. b), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // press NEXT
    NEXT = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b10 && WINNER == 4'hb && FALSE_START == 1'b0 && DATA == 10'd550 && ADDRESS == 3'b111) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Pressing NEXT after end of game correctly has no effect. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 30: Pressing NEXT after end of game should not have any effect. DATA from prandom is %3d, should be 550 (ADDRESS = %3b, should be 111). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 2), WINNER = %1h (exp. b), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end


    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;


    $display("MSIM> ");
    $display("MSIM> TEST 2: HOLDING DOWN NEXT, RESET IN THE MIDDLE");
    $display("MSIM> ==============================================");
    $display("MSIM> ");


    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 31: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 32: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 200 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 200; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 33: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 200-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 34: Error with signaling after 200-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 35: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 10 cycles to skip to just after end of false start period...");

    #1000;  // wait ten cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait one cycle

    // simulate Player A letting go immediately
    PLAYER_A = 1'b1;

    #100;  // wait a second cycle to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A and started next round when button pressed after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 36: Error with giving point to Player A and starting next round when button pressed after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A letting go immediately
    PLAYER_A = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 150 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 150; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        $display("MSIM> ERROR 37: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 150-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 38: Error with signaling after 150-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 39: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 9 cycles to skip to just before end of false start period...");

    #900;  // wait nine cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player B and started next round  when Player A false starts. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 40: Error with giving point to Player B and starting next round  when Player A false starts. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    #100;  // wait a cycle to observe result

    // simulate Player B false starting immediately
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    // simulate Player B releasing button
    PLAYER_B = 1'b1;

    if(STATE == previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A and started next round when Player B false starts while beginning to count down. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 41: Error with giving point to Player A and starting next round when Player B false starts while beginning to count down. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 650 cycles (but will reset after 96)...");

    currentLoopFailed = 0;
    for(i = 0; i < 96; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 42: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Reset is correct, including blanking scores. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 43: Reset (with blanking of scores) is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // pull RESET low to advance to next state
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 44: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 200 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 200; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 45: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 200-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 46: Error with signaling after 200-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 47: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 25 cycles to skip false start period...");

    #2500;  // wait 25 cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A and started new round when button pressed after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 48: Error with giving point to Player A and starting new round when button pressed after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    previousState = STATE;
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 300 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 300; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 49: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 300-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 50: Error with signaling after 300-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 51: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 12 cycles to skip false start period...");

    #1200;  // wait twelve cycles

    // simulate both players reacting immediately
    PLAYER_A = 1'b0;
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b10 && SCORE_B == 4'b0 && WINNER == 4'ha && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player A when button pressing tied after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 52: Error with giving point/win to Player A when button pressing tied after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 2), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b10 && SCORE_B == 4'b0 && WINNER == 4'ha && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Holding down NEXT after end of game correctly has no effect. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 53: Pressing NEXT after end of game should not have any effect. STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 2), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end


    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;


    $display("MSIM> ");
    $display("MSIM> TEST 3: ONE REGULAR WIN, ONE FALSE START WIN");
    $display("MSIM> ============================================");
    $display("MSIM> ");


    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 54: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring RESET low
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd700 && ADDRESS == 3'b001) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      $display("MSIM> ERROR 55: Waiting after reset is incorrect. DATA from prandom is %3d, should be 700 (ADDRESS = %3b, should be 001). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 56: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 700 cycles (but will false start after 34)...");

    currentLoopFailed = 0;
    for(i = 0; i < 34; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 57: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    // simulate Player A and Player B pressing button simultaneously
    PLAYER_A = 1'b0;
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to register increment

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player B when button pressing tied during initial countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 58: Error with giving point/win to Player B when button pressing tied during initial countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd200 && ADDRESS == 3'b000) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 59: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd700 && ADDRESS == 3'b001) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 60: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 700 (ADDRESS = %3b, should be 001). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A and Player B releasing button
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd350 && ADDRESS == 3'b010) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 61: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 350 (ADDRESS = %3b, should be 010). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 62: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 350 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 350; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b1 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 63: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 350-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 64: Error with signaling after 350-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 65: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 14 cycles to skip to past the false start period...");

    #1400;  // wait fourteen cycles

    // simulate Player A reacting immediately
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'b0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point to Player A. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 66: Error with giving point to Player A. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button, and NEXT being pressed
    PLAYER_A = 1'b1;
    NEXT = 1'b0;

    previousState = STATE;
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 67: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 500 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 500; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b1 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 68: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 500-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 69: Error with signaling after 500-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Checking input if Player B false starts right as SIGNAL turns on...");

    // simulate Player B reacting immediately
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    // simulate Player B letting go immediately
    PLAYER_B = 1'b1;

    #100;  // wait one more cycle to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b10 && SCORE_B == 4'b0 && WINNER == 4'ha && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player A after Player B false started. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 70: Error with giving point/win to Player A after Player B false started. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 2), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end


    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;


    $display("MSIM> ");
    $display("MSIM> TEST 4: TWO FALSE START WINS");
    $display("MSIM> ============================");
    $display("MSIM> ");


    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 71: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring RESET low
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd700 && ADDRESS == 3'b001) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      $display("MSIM> ERROR 72: Waiting after reset is incorrect. DATA from prandom is %3d, should be 700 (ADDRESS = %3b, should be 001). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 73: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 700 cycles (but will false start after 13)...");

    currentLoopFailed = 0;
    for(i = 0; i < 13; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 74: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    // simulate Player A pressing button
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to register increment

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player B when A false starts initial countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 75: Error with giving point/win to Player B when button pressing tied during initial countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b1 && DATA == 10'd500 && ADDRESS == 3'b011) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Waiting after end of round is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 76: Waiting after end of round is incorrect. DATA from prandom is %3d, should be 500 (ADDRESS = %3b, should be 011). STATE = %2d (expected %2d), SIGNAL = %1b (exp. 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 1)", DATA, ADDRESS, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 77: Asserting active-low NEXT does not advance state correctly. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 500 cycles...");

    currentLoopFailed = 0;
    for(i = 0; i < 500; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b1 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        currentLoopFailed = 1;
        $display("MSIM> ERROR 78: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(currentLoopFailed == 0) begin
      numTestsPassed = numTestsPassed + 1;
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly signaled after 500-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 79: Error with signaling after 500-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 80: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 4 cycles so that we are still in the false start period...");

    #400;  // wait four cycles

    // simulate Player A and Player B reacting simultaneously
    PLAYER_A = 1'b0;
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #200;  // wait two cycles to observe result after score counter is incremented

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b10 && WINNER == 4'hb && FALSE_START == 1'b1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> Correctly gave point/win to Player B after both players tied and false started. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 81: Error with giving point/win to Player B after both players tied and false started. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 2), WINNER = %1h (exp. b), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end


    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;



    $display("MSIM> ");
    if(currentTestCorrect == 1) begin
      $display("MSIM> FSM IS CORRECT        o   o");
      $display("MSIM>  %2d out of 81           |  ", numTestsPassed);
      $display("MSIM> checks passed!        \\___/");
    end
    else begin
      $display("MSIM> FSM IS INCORRECT      o   o");
      $display("MSIM>   %2d out of 81         ___ ", numTestsPassed);
      $display("MSIM>  checks passed!       /   \\ ");
    end
    $display("MSIM> ");



    $stop;






    $display("MSIM>");
    $display("MSIM> ===============================================================");
    $display("MSIM>");
    $display("MSIM> PART B PRELAB TEST CASES (can be ignored for Part B lab)");
    $display("MSIM>");
    $display("MSIM> ===============================================================");
    $display("MSIM>");


    numTestsPassed = 0;


    /* TESTS
       1. detecting false starts
       2. restarting the FSM and checking for false start ties
       3. restarting the FSM and checking for a proper false start countdown
    */


    $display("MSIM> ");
    $display("MSIM> TEST 1: DETECTING FALSE STARTS");
    $display("MSIM> ==============================");
    $display("MSIM> ");

    currentTestCorrect = 1;

    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 82: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 83: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // test to see if NEXT is ignored during reset
    NEXT = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> NEXT is correctly ignored during reset. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 84: NEXT not ignored during reset. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // test to see if state stays the same when reset is brought low
    NEXT = 1'b1;
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Waiting at initial state with no signals asserted is correct. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 85: Waiting at initial state with no signals asserted is incorrect. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // test to see if PLAYER_A input affects the state
    PLAYER_A = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Setting PLAYER_A to 0 (active) correctly has no effect on initial state. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 86: Setting PLAYER_A to 0 (active) incorrectly changed the outputs. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // test to see if PLAYER_B input affects the state
    PLAYER_B = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Setting PLAYER_A and PLAYER_B to 0 (active) correctly has no effect on initial state. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 87: Setting PLAYER_A and PLAYER_B to 0 (active) incorrectly changed the state. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring PLAYER_A back high (inactive)
    PLAYER_A = 1'b1;

    #100;  // wait a cycle to observe results

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Setting PLAYER_B to 0 (active) correctly has no effect on initial state. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 88: Setting PLAYER_B to 0 (active) incorrectly changed the state. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring PLAYER_B back high (inactive)
    PLAYER_B = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Waiting at initial state with no signals asserted is correct. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 89: Waiting at initial state with no signals asserted is incorrect. STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd150 && ADDRESS == 3'b110) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 90: DATA from prandom is %3d, should be 300 (ADDRESS = %3b, should be 110). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd550 && ADDRESS == 3'b111) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 91: DATA from prandom is %3d, should be 550 (ADDRESS = %3b, should be 111). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b000) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 92: DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd700 && ADDRESS == 3'b001) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 93: DATA from prandom is %3d, should be 700 (ADDRESS = %3b, should be 001). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd350 && ADDRESS == 3'b010) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 94: DATA from prandom is %3d, should be 350 (ADDRESS = %3b, should be 010). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd500 && ADDRESS == 3'b011) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 95: DATA from prandom is %3d, should be 500 (ADDRESS = %3b, should be 011). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd650 && ADDRESS == 3'b100) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 96: DATA from prandom is %3d, should be 650 (ADDRESS = %3b, should be 100). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd300 && ADDRESS == 3'b101) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 97: DATA from prandom is %3d, should be 300 (ADDRESS = %3b, should be 101). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd150 && ADDRESS == 3'b110) begin
      $display("MSIM> Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 98: DATA from prandom is %3d, should be 150 (ADDRESS = %3b, should be 110). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 99: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // let go of NEXT
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 150 cycles...");

    for(i = 0; i < 150; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        $display("MSIM> ERROR 100: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly signaled after 150-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 101: Error with signaling after 150-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 102: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 9 cycles to skip to just before end of false start period...");

    #900;  // wait nine cycles

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 103: Not properly waiting while signaling. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player B reacting
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly gave point/win to Player A when Player B false starts. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 104: Error with giving point/win to Player A when Player B false starts. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly waiting after false start. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 105: Not properly waiting after false start. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A reacting
    PLAYER_A = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly unaffected by Player A after Player B's false start. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 106: Should not be affected by Player A after Player B's false start. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player B releasing button
    PLAYER_B = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly unaffected by Player B releasing button after false start. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 107: Should not be affected by Player B releasing button after false start. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // simulate Player A releasing button
    PLAYER_A = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly unaffected by Player A releasing button after false start. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 108: Should not be affected by Player A releasing button after false start. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // check if pressing NEXT has any effect
    NEXT = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE == previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly unaffected by NEXT button after false start. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 109: Should not be affected by NEXT button after false start. STATE = %2d (should be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    $display("MSIM> ");
    if(currentTestCorrect == 1) begin
      numTestsPassed = numTestsPassed + 2;
      $display("MSIM> TEST 1 PASSED");
    end
    else begin
      $display("MSIM> TEST 1 FAILED (-2 pt)");
    end
    $display("MSIM> ");



    $display("MSIM> ");
    $display("MSIM> TEST 2: RESTARTING THE FSM AND CHECKING FOR FALSE START TIES");
    $display("MSIM> ============================================================");
    $display("MSIM> ");

    currentTestCorrect = 1;

    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 110: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 111: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 200 cycles (but will trigger a false start after 79)...");

    for(i = 0; i < 79; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        $display("MSIM> ERROR 112: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    // simulate Players A and B reacting immediately
    PLAYER_A = 1'b0;
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b1 && WINNER == 4'hB && FALSE_START == 1'b1) begin
      $display("MSIM> Correctly gave point/win to Player B when both players false start simultaneously. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 113: Error with giving point/win to Player B when both players false start simultaneously. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 1), WINNER = %1h (exp. b), FALSE_START = %1b (exp. 1)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;

    $display("MSIM> ");
    if(currentTestCorrect == 1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> TEST 2 PASSED");
    end
    else begin
      $display("MSIM> TEST 2 FAILED (-1 pt)");
    end
    $display("MSIM> ");



    $display("MSIM> ");
    $display("MSIM> TEST 3: RESETTING THE FSM AND PLAYING A NON FALSE START GAME");
    $display("MSIM> ============================================================");
    $display("MSIM> ");

    currentTestCorrect = 1;

    // reset circuit
    RESET = 1'b1;

    #100;  // wait a cycle to observe result

    if(STATE == 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0 && DATA == 10'd200 && ADDRESS == 3'b0) begin
      $display("MSIM> Reset is correct. Reading delay of %3d (DATA at ADDRESS %3b) correctly from prandom. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 114: Reset is incorrect. DATA from prandom is %3d, should be 200 (ADDRESS = %3b, should be 000). STATE = %2d (expected 0), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", DATA, ADDRESS, STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // assert NEXT to advance to next state
    NEXT = 1'b0;
    RESET = 1'b0;

    #100;  // wait a cycle to observe result

    if(STATE != 4'b0 && SIGNAL == 1'b0 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Asserting active-low NEXT advances states correctly. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 115: Asserting active-low NEXT does not advance state correctly. STATE = %2d, SIGNAL = %1b (expected 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // bring NEXT back up; should not have any effect
    NEXT = 1'b1;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    $display("MSIM> Beginning to countdown for 200 cycles...");

    for(i = 0; i < 200; i = i + 1) begin
      if(STATE != previousState || SIGNAL != 1'b0 || SCORE_A != 4'b0 || SCORE_B != 4'b0 || WINNER != 4'h0 && FALSE_START == 1'b0) begin
        currentTestCorrect = 0;
        $display("MSIM> ERROR 116: Countdown is incorrect, or may have changed states. %3d cycles in, STATE = %2d (expected %2d), SIGNAL = %1b (exp. 0), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", i, STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
      end

      #100;  // wait a cycle to observe result
    end

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly signaled after 200-cycle countdown. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 117: Error with signaling after 200-cycle countdown. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(SIGNAL == 1'b1 && SCORE_A == 4'b0 && SCORE_B == 4'b0 && WINNER == 4'h0 && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly waiting while signaling. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 118: Not properly waiting while signaling. STATE = %2d, SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 0), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. 0), FALSE_START = %1b (exp. 0)", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    previousState = STATE;  // save state to check advancement

    $display("MSIM> Advancing 10 cycles to skip to just after end of false start period...");

    #1000;  // wait ten cycles

    // simulate Players A and B reacting immediately
    PLAYER_A = 1'b0;
    PLAYER_B = 1'b0;

    previousState = STATE;  // save state to check advancement
    #100;  // wait a cycle to observe result

    if(STATE != previousState && SIGNAL == 1'b1 && SCORE_A == 4'b1 && SCORE_B == 4'b0 && WINNER == 4'hA && FALSE_START == 1'b0) begin
      $display("MSIM> Correctly gave point/win to Player A when both buttons pressed simultaneously after false start period passes. STATE = %2d, SIGNAL = %1b, SCORE_A = %1h, SCORE_B = %1h, WINNER = %1h, FALSE_START = %1b", STATE, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end
    else begin
      currentTestCorrect = 0;
      $display("MSIM> ERROR 119: Error with giving point/win to Player A when both buttons pressed simultaneously after false start period passes. STATE = %2d (should not be %2d), SIGNAL = %1b (expected 1), SCORE_A = %1h (exp. 1), SCORE_B = %1h (exp. 0), WINNER = %1h (exp. a), FALSE_START = %1b (exp. 0)", STATE, previousState, SIGNAL, SCORE_A, SCORE_B, WINNER, FALSE_START);
    end

    // reset buttons now that test is complete
    NEXT = 1'b1;
    PLAYER_A = 1'b1;
    PLAYER_B = 1'b1;

    $display("MSIM> ");
    if(currentTestCorrect == 1) begin
      numTestsPassed = numTestsPassed + 1;
      $display("MSIM> TEST 3 PASSED");
    end
    else begin
      $display("MSIM> TEST 3 FAILED (-1 pt)");
    end
    $display("MSIM> ");


    // print final score
    $display("MSIM> ");
    $display("MSIM> Prelab 4b Score: %2d / 4", numTestsPassed);

    // Since the clock (see above) always keeps alternating, the test bench will never run out
    // of things to do.  As a result, we need to tell ModelSim to explicitly stop once we are
    // done with all of our test cases.
    $stop;
  end

endmodule
