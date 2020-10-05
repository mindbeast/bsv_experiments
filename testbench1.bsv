
package testbench1;

(* synthesize *)
module mkTestbench (Empty);
   Reg #(Bit #(16)) counter <- mkReg (0);

   rule print_rule (counter < 16);
       $display ("%d counter:", counter);
       counter <= counter + 1;
   endrule
   rule end_rule (counter == 16);
      $finish ();
   endrule
endmodule: mkTestbench

endpackage: testbench1

