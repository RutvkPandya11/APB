module apb_master (
    input wire PCLK,
    input wire PRESETn,
    output reg PSEL1,
    output reg PSEL2,
    output reg PENABLE,
    output reg PWRITE,
    output reg [31:0] PADDR,
    output reg [31:0] PWDATA,
    output reg [3:0] PSTRB,
    input wire [31:0] PRDATA1,
    input wire [31:0] PRDATA2,
    input wire PREADY1,
    input wire PREADY2,
    input wire PSLVERR1,
    input wire PSLVERR2
);
    // State definitions using parameter
    parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;
    reg [1:0] state;

    // State machine
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            state <= IDLE;
            PSEL1 <= 0;
            PSEL2 <= 0;
            PENABLE <= 0;
            PWRITE <= 0;
            PADDR <= 32'b0;
            PWDATA <= 32'b0;
            PSTRB <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    $display("State: IDLE");
                    PSEL1 <= 1;
                    PSEL2 <= 0;
                    PADDR <= 32'h0000_0004; // Example address
                    PWRITE <= 1; // Write operation
                    PWDATA <= 32'h1234_5678; // Example data
                    PSTRB <= 4'b1111; // All byte lanes active
                    state <= SETUP;
                end
                SETUP: begin
                    $display("State: SETUP");
                    PENABLE <= 1;
                    state <= ACCESS;
                end
                ACCESS: begin
                    $display("State: ACCESS, PREADY1 = %b, PSLVERR1 = %b", PREADY1, PSLVERR1);
                    if (PREADY1) begin
                        PENABLE <= 0;
                        PSEL1 <= 0;
                        state <= IDLE;
                    end else if (PSLVERR1) begin
                        // Handle error
                        PENABLE <= 0;
                        PSEL1 <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
