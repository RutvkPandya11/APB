module tb_apb;
    reg PCLK;
    reg PRESETn;
    wire PSEL1;
    wire PSEL2;
    wire PENABLE;
    wire PWRITE;
    wire [31:0] PADDR;
    wire [31:0] PWDATA;
    wire [3:0] PSTRB;
    wire [31:0] PRDATA1;
    wire [31:0] PRDATA2;
    wire PREADY1;
    wire PREADY2;
    wire PSLVERR1;
    wire PSLVERR2;

    // Instantiate APB Master
    apb_master master (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL1(PSEL1),
        .PSEL2(PSEL2),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PRDATA1(PRDATA1),
        .PRDATA2(PRDATA2),
        .PREADY1(PREADY1),
        .PREADY2(PREADY2),
        .PSLVERR1(PSLVERR1),
        .PSLVERR2(PSLVERR2)
    );

    // Instantiate APB Slaves
    apb_slave slave1 (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL1),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PRDATA(PRDATA1),
        .PREADY(PREADY1),
        .PSLVERR(PSLVERR1)
    );

    apb_slave slave2 (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL2),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PSTRB(PSTRB),
        .PRDATA(PRDATA2),
        .PREADY(PREADY2),
        .PSLVERR(PSLVERR2)
    );

    // Clock generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t, PCLK = %b, PRESETn = %b, PSEL1 = %b, PSEL2 = %b, PENABLE = %b, PWRITE = %b, PADDR = %h, PWDATA = %h, PSTRB = %b, PRDATA1 = %h, PRDATA2 = %h, PREADY1 = %b, PREADY2 = %b, PSLVERR1 = %b, PSLVERR2 = %b", 
                 $time, PCLK, PRESETn, PSEL1, PSEL2, PENABLE, PWRITE, PADDR, PWDATA, PSTRB, PRDATA1, PRDATA2, PREADY1, PREADY2, PSLVERR1, PSLVERR2);
    end

    // Dump waveforms
    initial begin
        $dumpfile("tb_apb.vcd");
        $dumpvars(0, tb_apb);
    end

    // Reset and test sequence
    initial begin
        PRESETn = 0;
        #10 PRESETn = 1;

        // Test sequence for write operation to slave 1
        #20;
        master.PADDR = 32'h0000_0004;
        master.PWRITE = 1;
        master.PWDATA = 32'h1234_5678;
        master.PSTRB = 4'b1111;
        master.PSEL1 = 1;
        master.PENABLE = 1;
        #10;
        master.PENABLE = 0;
        master.PSEL1 = 0;
        #20;

        // Test sequence for read operation from slave 1
        #20;
        master.PADDR = 32'h0000_0004;
        master.PWRITE = 0;
        master.PSEL1 = 1;
        master.PENABLE = 1;
        #10;
        master.PENABLE = 0;
        master.PSEL1 = 0;
        #20;

        // Test sequence for write operation to slave 2
        #20;
        master.PADDR = 32'h0000_0008;
        master.PWRITE = 1;
        master.PWDATA = 32'h8765_4321;
        master.PSTRB = 4'b1111;
        master.PSEL2 = 1;
        master.PENABLE = 1;
        #10;
        master.PENABLE = 0;
        master.PSEL2 = 0;
        #20;

        // Test sequence for read operation from slave 2
        #20;
        master.PADDR = 32'h0000_0008;
        master.PWRITE = 0;
        master.PSEL2 = 1;
        master.PENABLE = 1;
        #10;
        master.PENABLE = 0;
        master.PSEL2 = 0;
        #20;

        // End simulation
        #100;
        $finish;
    end
endmodule
