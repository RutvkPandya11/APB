module apb_master (
    input wire PCLK, PRESETn, PREADY1, PREADY2, PSLVERR1, PSLVERR2, 
    output reg PSEL1, PSEL2, PENABLE, PWRITE,
    output reg [31:0] PADDR, PWDATA,
    output reg [3:0] PSTRB,
    input wire [31:0] PRDATA1, PRDATA2
);
    // State definitions using parameter
    parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;
    reg [1:0] state, next_state;

    // State transition logic
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next_state = state;
        PSEL1 = 0;
        PSEL2 = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 32'b0;
        PWDATA = 32'b0;
        PSTRB = 4'b0;

        case (state)
            IDLE: begin
                $display("State: IDLE");
                PSEL1 = 1;
                PADDR = 32'h0000_0004; // Example address
                PWRITE = 1; // Write operation
                PWDATA = 32'h1234_5678; // Example data
                PSTRB = 4'b1111; // All byte lanes active
                next_state = SETUP;
            end
            SETUP: begin
                $display("State: SETUP");
                PENABLE = 1;
                next_state = ACCESS;
            end
            ACCESS: begin
                $display("State: ACCESS, PREADY1 = %b, PSLVERR1 = %b, PREADY2 = %b, PSLVERR2 = %b", PREADY1, PSLVERR1, PREADY2, PSLVERR2);
                PENABLE = 1;
                if (PREADY1 || PREADY2) begin
                    next_state = IDLE;
                end else if (PSLVERR1 || PSLVERR2) begin
                    // Handle error
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule
