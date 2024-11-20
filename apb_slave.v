module apb_slave (
    input wire PCLK,
    input wire PRESETn,
    input wire PSEL,
    input wire PENABLE,
    input wire PWRITE,
    input wire [31:0] PADDR,
    input wire [31:0] PWDATA,
    input wire [3:0] PSTRB,
    output reg [31:0] PRDATA,
    output reg PREADY,
    output reg PSLVERR
);
    reg [31:0] memory [0:255]; // Example memory

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PREADY <= 0;
            PSLVERR <= 0;
            PRDATA <= 32'b0;
            // Optionally initialize memory here
        end else if (PSEL && PENABLE) begin
            PREADY <= 1;
            PSLVERR <= 0; // Clear error signal
            if (PWRITE) begin
                if (PADDR < 256) begin // Check for valid address range
                    if (PSTRB[0]) memory[PADDR][7:0] <= PWDATA[7:0];
                    if (PSTRB[1]) memory[PADDR][15:8] <= PWDATA[15:8];
                    if (PSTRB[2]) memory[PADDR][23:16] <= PWDATA[23:16];
                    if (PSTRB[3]) memory[PADDR][31:24] <= PWDATA[31:24];
                end else begin
                    PSLVERR <= 1; // Set error signal for invalid address
                end
            end else begin
                if (PADDR < 256) begin // Check for valid address range
                    PRDATA <= memory[PADDR];
                end else begin
                    PSLVERR <= 1; // Set error signal for invalid address
                end
            end
        end else begin
            PREADY <= 0;
        end
    end
endmodule
