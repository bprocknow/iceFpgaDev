
module top_hello (input BTN1, output LED1);
	always@ (*) begin
		LED1 = BTN1;
	end
endmodule
