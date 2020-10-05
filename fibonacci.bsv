package fibonacci;

import  ClientServer :: *;

interface FibonacciInterface;
    interface Server #(Bit#(32), Bit#(32)) server;
endinterface

typedef enum { IDLE, THINKING, DONE } FibState  deriving (Eq, Bits, FShow);

(* synthesize *)
module mkFibonacciGenerator (FibonacciInterface);
    Reg #(FibState) state <- mkReg (IDLE);
    Reg #(Bit#(32)) counter <- mkReg(0);
    Reg #(Bit#(32)) cur <- mkReg(0);
    Reg #(Bit#(32)) prev <- mkReg(0);

    rule calc (state == THINKING && counter != 0);
        prev <= cur;
        cur <= prev + cur;
        counter <= counter - 1;
        if (counter == 1) 
            state <= DONE;
    endrule

    interface Server server;
        interface Put request;
            method Action put(Bit#(32) index) if (state == IDLE);
                 state <= THINKING;
                 cur <= 1;
                 prev <= 0;
                 counter <= index;
            endmethod
        endinterface
        interface Get response;
            method ActionValue#(Bit#(32)) get() if (state == DONE);
                 state <= IDLE; 
                 return cur;
            endmethod
        endinterface
    endinterface
   
endmodule: mkFibonacciGenerator


(* synthesize *)
module mkTestbench(Empty);
    FibonacciInterface fib <- mkFibonacciGenerator();
    rule kick;
        fib.server.request.put(10);
    endrule
    rule get;
        Bit#(32) result = fib.server.response.get(10);
        $display("result %d\n", result);
    endrule
endmodule: mkTestbench

endpackage: fibonacci

