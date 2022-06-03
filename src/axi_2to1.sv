`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2022 10:14:10 AM
// Design Name: 
// Module Name: axi_2to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_2to1(
input       aclk,
input       aresetn,

axi4.slave  s_axi0,
axi4.slave  s_axi1
    );
    


wire M00_AXI_ARESET_OUT_N;
wire M00_AXI_ACLK;
wire [3 : 0] M00_AXI_AWID;
wire [31 : 0] M00_AXI_AWADD;
wire [7 : 0] M00_AXI_AWLEN;
wire [2 : 0] M00_AXI_AWSIZE;
wire [1 : 0] M00_AXI_AWBURS;
wire M00_AXI_AWLOCK;
wire [3 : 0] M00_AXI_AWCACH;
wire [2 : 0] M00_AXI_AWPROT;
wire [3 : 0] M00_AXI_AWQOS;
wire M00_AXI_AWVALID;
wire M00_AXI_AWREADY;
wire [31 : 0] M00_AXI_WDATA;
wire [3 : 0] M00_AXI_WSTRB;
wire M00_AXI_WLAST;
wire M00_AXI_WVALID;
wire M00_AXI_WREADY;
wire [3 : 0] M00_AXI_BID;
wire [1 : 0] M00_AXI_BRESP;
wire M00_AXI_BVALID;
wire M00_AXI_BREADY;
wire [3 : 0] M00_AXI_ARID;
wire [31 : 0] M00_AXI_ARADD;
wire [7 : 0] M00_AXI_ARLEN;
wire [2 : 0] M00_AXI_ARSIZE;
wire [1 : 0] M00_AXI_ARBURS;
wire M00_AXI_ARLOCK;
wire [3 : 0] M00_AXI_ARCACH;
wire [2 : 0] M00_AXI_ARPROT;
wire [3 : 0] M00_AXI_ARQOS;
wire M00_AXI_ARVALID;
wire M00_AXI_ARREADY;
wire [3 : 0] M00_AXI_RID;
wire [31 : 0] M00_AXI_RDATA;
wire [1 : 0] M00_AXI_RRESP;
wire M00_AXI_RLAST;
wire M00_AXI_RVALID;
wire M00_AXI_RREADY;



   system_management_wiz
   system_management_wiz_inst (
     .s_axi_aclk      (m_axi0.ACLK),                    
     .s_axi_aresetn   (M00_AXI_ARESET_OUT_N),                    
 
     .s_axi_awaddr    (M00_AXI_AWADDR),                    
     .s_axi_awvalid   (M00_AXI_AWVALID),                    
     .s_axi_awready   (M00_AXI_AWVALID),                    
     .s_axi_wdata     (M00_AXI_WDATA),                    
     .s_axi_wstrb     (4'hF),                    
     .s_axi_wvalid    (M00_AXI_WVALID),                    
     .s_axi_wready    (M00_AXI_WREADY),                    
     .s_axi_bresp     (M00_AXI_BRESP),                    
     .s_axi_bvalid    (M00_AXI_BVALID),                    
     .s_axi_bready    (M00_AXI_BREADY),                    
     .s_axi_araddr    (M00_AXI_ARADDR),                    
     .s_axi_arvalid   (M00_AXI_ARVALID),                    
     .s_axi_arready   (M00_AXI_ARREADY),                    
     .s_axi_rdata     (M00_AXI_RDATA),                    
     .s_axi_rresp     (M00_AXI_RRESP),                    
     .s_axi_rvalid    (M00_AXI_RVALID),                    
     .s_axi_rready    (M00_AXI_RREADY)
  );



axi_interconnect_2to1 u_axi_2to1 (

  .INTERCONNECT_ACLK      (aclk),        // input wire INTERCONNECT_ACLK
  .INTERCONNECT_ARESETN     (aresetn),  // input wire INTERCONNECT_ARESETN
  
  .M00_AXI_ARESET_OUT_N(M00_AXI_ARESET_OUT_N),  // output wire M00_AXI_ARESET_OUT_N
  .M00_AXI_ACLK(M00_AXI_ACLK),                  // input  wire M00_AXI_ACLK
  .M00_AXI_AWID(M00_AXI_AWID),                  // output wire [3 : 0] M00_AXI_AWID
  .M00_AXI_AWADDR(M00_AXI_AWADDR),              // output wire [31 : 0] M00_AXI_AWADDR
  .M00_AXI_AWLEN(M00_AXI_AWLEN),                // output wire [7 : 0] M00_AXI_AWLEN
  .M00_AXI_AWSIZE(M00_AXI_AWSIZE),              // output wire [2 : 0] M00_AXI_AWSIZE
  .M00_AXI_AWBURST(M00_AXI_AWBURST),            // output wire [1 : 0] M00_AXI_AWBURST
  .M00_AXI_AWLOCK(M00_AXI_AWLOCK),              // output wire M00_AXI_AWLOCK
  .M00_AXI_AWCACHE(M00_AXI_AWCACHE),            // output wire [3 : 0] M00_AXI_AWCACHE
  .M00_AXI_AWPROT(M00_AXI_AWPROT),              // output wire [2 : 0] M00_AXI_AWPROT
  .M00_AXI_AWQOS(M00_AXI_AWQOS),                // output wire [3 : 0] M00_AXI_AWQOS
  .M00_AXI_AWVALID(M00_AXI_AWVALID),            // output wire M00_AXI_AWVALID
  .M00_AXI_AWREADY(M00_AXI_AWREADY),            // input  wire M00_AXI_AWREADY
  .M00_AXI_WDATA(M00_AXI_WDATA),                // output wire [31 : 0] M00_AXI_WDATA
  .M00_AXI_WSTRB(M00_AXI_WSTRB),                // output wire [3 : 0] M00_AXI_WSTRB
  .M00_AXI_WLAST(M00_AXI_WLAST),                // output wire M00_AXI_WLAST
  .M00_AXI_WVALID(M00_AXI_WVALID),              // output wire M00_AXI_WVALID
  .M00_AXI_WREADY(M00_AXI_WREADY),              // input  wire M00_AXI_WREADY
  .M00_AXI_BID(M00_AXI_BID),                    // input  wire [3 : 0] M00_AXI_BID
  .M00_AXI_BRESP(M00_AXI_BRESP),                // input  wire [1 : 0] M00_AXI_BRESP
  .M00_AXI_BVALID(M00_AXI_BVALID),              // input  wire M00_AXI_BVALID
  .M00_AXI_BREADY(M00_AXI_BREADY),              // output wire M00_AXI_BREADY
  .M00_AXI_ARID(M00_AXI_ARID),                  // output wire [3 : 0] M00_AXI_ARID
  .M00_AXI_ARADDR(M00_AXI_ARADDR),              // output wire [31 : 0] M00_AXI_ARADDR
  .M00_AXI_ARLEN(M00_AXI_ARLEN),                // output wire [7 : 0] M00_AXI_ARLEN
  .M00_AXI_ARSIZE(M00_AXI_ARSIZE),              // output wire [2 : 0] M00_AXI_ARSIZE
  .M00_AXI_ARBURST(M00_AXI_ARBURST),            // output wire [1 : 0] M00_AXI_ARBURST
  .M00_AXI_ARLOCK(M00_AXI_ARLOCK),              // output wire M00_AXI_ARLOCK
  .M00_AXI_ARCACHE(M00_AXI_ARCACHE),            // output wire [3 : 0] M00_AXI_ARCACHE
  .M00_AXI_ARPROT(M00_AXI_ARPROT),              // output wire [2 : 0] M00_AXI_ARPROT
  .M00_AXI_ARQOS(M00_AXI_ARQOS),                // output wire [3 : 0] M00_AXI_ARQOS
  .M00_AXI_ARVALID(M00_AXI_ARVALID),            // output wire M00_AXI_ARVALID
  .M00_AXI_ARREADY(M00_AXI_ARREADY),            // input  wire M00_AXI_ARREADY
  .M00_AXI_RID(M00_AXI_RID),                    // input  wire [3 : 0] M00_AXI_RID
  .M00_AXI_RDATA(M00_AXI_RDATA),                // input  wire [31 : 0] M00_AXI_RDATA
  .M00_AXI_RRESP(M00_AXI_RRESP),                // input  wire [1 : 0] M00_AXI_RRESP
  .M00_AXI_RLAST(M00_AXI_RLAST),                // input  wire M00_AXI_RLAST
  .M00_AXI_RVALID(M00_AXI_RVALID),              // input  wire M00_AXI_RVALID
  .M00_AXI_RREADY(M00_AXI_RREADY),              // output wire M00_AXI_RREADY

  .S00_AXI_ARESET_OUT_N     (),  // output wire S00_AXI_ARESET_OUT_N
  .S00_AXI_ACLK         (s_axi0.ACLK),                  // input wire S00_AXI_ACLK
  .S00_AXI_AWID         (s_axi0.AWID),                  // input wire [0 : 0] S00_AXI_AWID
  .S00_AXI_AWADDR       (s_axi0.AWADDR),              // input wire [31 : 0] S00_AXI_AWADDR
  .S00_AXI_AWLEN        (s_axi0.AWLEN),                // input wire [7 : 0] S00_AXI_AWLEN
  .S00_AXI_AWSIZE       (s_axi0.AWSIZE),              // input wire [2 : 0] S00_AXI_AWSIZE
  .S00_AXI_AWBURST        (s_axi0.AWBURST),            // input wire [1 : 0] S00_AXI_AWBURST
  .S00_AXI_AWLOCK       (s_axi0.AWLOCK),              // input wire S00_AXI_AWLOCK
  .S00_AXI_AWCACHE        (s_axi0.AWCACHE),            // input wire [3 : 0] S00_AXI_AWCACHE
  .S00_AXI_AWPROT       (s_axi0.AWPROT),              // input wire [2 : 0] S00_AXI_AWPROT
  .S00_AXI_AWQOS        (s_axi0.AWQOS),                // input wire [3 : 0] S00_AXI_AWQOS
  .S00_AXI_AWVALID        (s_axi0.AWVALID),            // input wire S00_AXI_AWVALID
  .S00_AXI_AWREADY        (s_axi0.AWREADY),            // output wire S00_AXI_AWREADY
  .S00_AXI_WDATA        (s_axi0.WDATA),                // input wire [31 : 0] S00_AXI_WDATA
  .S00_AXI_WSTRB        (s_axi0.WSTRB),                // input wire [3 : 0] S00_AXI_WSTRB
  .S00_AXI_WLAST        (s_axi0.WLAST),                // input wire S00_AXI_WLAST
  .S00_AXI_WVALID       (s_axi0.WVALID),              // input wire S00_AXI_WVALID
  .S00_AXI_WREADY       (s_axi0.WREADY),              // output wire S00_AXI_WREADY
  .S00_AXI_BID          (s_axi0.BID),                    // output wire [0 : 0] S00_AXI_BID
  .S00_AXI_BRESP        (s_axi0.BRESP),                // output wire [1 : 0] S00_AXI_BRESP
  .S00_AXI_BVALID       (s_axi0.BVALID),              // output wire S00_AXI_BVALID
  .S00_AXI_BREADY       (s_axi0.BREADY),              // input wire S00_AXI_BREADY
  .S00_AXI_ARID         (s_axi0.ARID),                  // input wire [0 : 0] S00_AXI_ARID
  .S00_AXI_ARADDR       (s_axi0.ARADDR),              // input wire [31 : 0] S00_AXI_ARADDR
  .S00_AXI_ARLEN        (s_axi0.ARLEN),                // input wire [7 : 0] S00_AXI_ARLEN
  .S00_AXI_ARSIZE       (s_axi0.ARSIZE),              // input wire [2 : 0] S00_AXI_ARSIZE
  .S00_AXI_ARBURST        (s_axi0.ARBURST),            // input wire [1 : 0] S00_AXI_ARBURST
  .S00_AXI_ARLOCK       (s_axi0.ARLOCK),              // input wire S00_AXI_ARLOCK
  .S00_AXI_ARCACHE        (s_axi0.ARCACHE),            // input wire [3 : 0] S00_AXI_ARCACHE
  .S00_AXI_ARPROT       (s_axi0.ARPROT),              // input wire [2 : 0] S00_AXI_ARPROT
  .S00_AXI_ARQOS        (s_axi0.ARQOS),                // input wire [3 : 0] S00_AXI_ARQOS
  .S00_AXI_ARVALID        (s_axi0.ARVALID),            // input wire S00_AXI_ARVALID
  .S00_AXI_ARREADY        (s_axi0.ARREADY),            // output wire S00_AXI_ARREADY
  .S00_AXI_RID          (s_axi0.RID),                    // output wire [0 : 0] S00_AXI_RID
  .S00_AXI_RDATA        (s_axi0.RDATA),                // output wire [31 : 0] S00_AXI_RDATA
  .S00_AXI_RRESP        (s_axi0.RRESP),                // output wire [1 : 0] S00_AXI_RRESP
  .S00_AXI_RLAST        (s_axi0.RLAST),                // output wire S00_AXI_RLAST
  .S00_AXI_RVALID       (s_axi0.RVALID),              // output wire S00_AXI_RVALID
  .S00_AXI_RREADY       (s_axi0.RREADY),              // input wire S00_AXI_RREADY

  .S01_AXI_ARESET_OUT_N     (),  // output wire S00_AXI_ARESET_OUT_N
  .S01_AXI_ACLK         (s_axi1.ACLK),                  // input wire S00_AXI_ACLK
  .S01_AXI_AWID         (s_axi1.AWID),                  // input wire [0 : 0] S00_AXI_AWID
  .S01_AXI_AWADDR       (s_axi1.AWADDR),              // input wire [31 : 0] S00_AXI_AWADDR
  .S01_AXI_AWLEN        (s_axi1.AWLEN),                // input wire [7 : 0] S00_AXI_AWLEN
  .S01_AXI_AWSIZE       (s_axi1.AWSIZE),              // input wire [2 : 0] S00_AXI_AWSIZE
  .S01_AXI_AWBURST        (s_axi1.AWBURST),            // input wire [1 : 0] S00_AXI_AWBURST
  .S01_AXI_AWLOCK       (s_axi1.AWLOCK),              // input wire S00_AXI_AWLOCK
  .S01_AXI_AWCACHE        (s_axi1.AWCACHE),            // input wire [3 : 0] S00_AXI_AWCACHE
  .S01_AXI_AWPROT       (s_axi1.AWPROT),              // input wire [2 : 0] S00_AXI_AWPROT
  .S01_AXI_AWQOS        (s_axi1.AWQOS),                // input wire [3 : 0] S00_AXI_AWQOS
  .S01_AXI_AWVALID        (s_axi1.AWVALID),            // input wire S00_AXI_AWVALID
  .S01_AXI_AWREADY        (s_axi1.AWREADY),            // output wire S00_AXI_AWREADY
  .S01_AXI_WDATA        (s_axi1.WDATA),                // input wire [31 : 0] S00_AXI_WDATA
  .S01_AXI_WSTRB        (s_axi1.WSTRB),                // input wire [3 : 0] S00_AXI_WSTRB
  .S01_AXI_WLAST        (s_axi1.WLAST),                // input wire S00_AXI_WLAST
  .S01_AXI_WVALID       (s_axi1.WVALID),              // input wire S00_AXI_WVALID
  .S01_AXI_WREADY       (s_axi1.WREADY),              // output wire S00_AXI_WREADY
  .S01_AXI_BID          (s_axi1.BID),                    // output wire [0 : 0] S00_AXI_BID
  .S01_AXI_BRESP        (s_axi1.BRESP),                // output wire [1 : 0] S00_AXI_BRESP
  .S01_AXI_BVALID       (s_axi1.BVALID),              // output wire S00_AXI_BVALID
  .S01_AXI_BREADY       (s_axi1.BREADY),              // input wire S00_AXI_BREADY
  .S01_AXI_ARID         (s_axi1.ARID),                  // input wire [0 : 0] S00_AXI_ARID
  .S01_AXI_ARADDR       (s_axi1.ARADDR),              // input wire [31 : 0] S00_AXI_ARADDR
  .S01_AXI_ARLEN        (s_axi1.ARLEN),                // input wire [7 : 0] S00_AXI_ARLEN
  .S01_AXI_ARSIZE       (s_axi1.ARSIZE),              // input wire [2 : 0] S00_AXI_ARSIZE
  .S01_AXI_ARBURST        (s_axi1.ARBURST),            // input wire [1 : 0] S00_AXI_ARBURST
  .S01_AXI_ARLOCK       (s_axi1.ARLOCK),              // input wire S00_AXI_ARLOCK
  .S01_AXI_ARCACHE        (s_axi1.ARCACHE),            // input wire [3 : 0] S00_AXI_ARCACHE
  .S01_AXI_ARPROT       (s_axi1.ARPROT),              // input wire [2 : 0] S00_AXI_ARPROT
  .S01_AXI_ARQOS        (s_axi1.ARQOS),                // input wire [3 : 0] S00_AXI_ARQOS
  .S01_AXI_ARVALID        (s_axi1.ARVALID),            // input wire S00_AXI_ARVALID
  .S01_AXI_ARREADY        (s_axi1.ARREADY),            // output wire S00_AXI_ARREADY
  .S01_AXI_RID          (s_axi1.RID),                    // output wire [0 : 0] S00_AXI_RID
  .S01_AXI_RDATA        (s_axi1.RDATA),                // output wire [31 : 0] S00_AXI_RDATA
  .S01_AXI_RRESP        (s_axi1.RRESP),                // output wire [1 : 0] S00_AXI_RRESP
  .S01_AXI_RLAST        (s_axi1.RLAST),                // output wire S00_AXI_RLAST
  .S01_AXI_RVALID       (s_axi1.RVALID),              // output wire S00_AXI_RVALID
  .S01_AXI_RREADY       (s_axi1.RREADY),              // input wire S00_AXI_RREADY

);

endmodule
