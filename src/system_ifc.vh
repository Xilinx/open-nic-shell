
`define KEEP  (* keep="TRUE" *)
`define DEBUG (* mark_debug = "true" *)

interface	axi4
#(
parameter	ADDR_WIDTH = 32,
parameter	DATA_WIDTH = 32,
parameter	ID_WIDTH   = 4
);
`KEEP logic		ACLK;
`KEEP logic		ARESETN;
`KEEP logic		[ADDR_WIDTH-1:0]ARADDR;
`KEEP logic		[1:0]ARBURST;
`KEEP logic		[3:0]ARCACHE;
`KEEP logic		[ID_WIDTH-1:0]ARID;
`KEEP logic		[7:0]ARLEN;
`KEEP logic		ARLOCK;
`KEEP logic		[2:0]ARPROT;
`KEEP logic		[3:0]ARQOS;
`KEEP logic		ARREADY;
`KEEP logic		[3:0]ARREGION;
`KEEP logic		[2:0]ARSIZE;
`KEEP logic		ARVALID;
`KEEP logic		[ADDR_WIDTH-1:0]AWADDR;
`KEEP logic		[1:0]AWBURST;
`KEEP logic		[3:0]AWCACHE;
`KEEP logic		[ID_WIDTH-1:0]AWID;
`KEEP logic		[7:0]AWLEN;
`KEEP logic		AWLOCK;
`KEEP logic		[2:0]AWPROT;
`KEEP logic		[3:0]AWQOS;
`KEEP logic		AWREADY;
`KEEP logic		[3:0]AWREGION;
`KEEP logic		[2:0]AWSIZE;
`KEEP logic		AWVALID;
`KEEP logic		[ID_WIDTH-1:0]BID;
`KEEP logic		BREADY;
`KEEP logic		[1:0]BRESP;
`KEEP logic		BVALID;
`KEEP logic		[DATA_WIDTH-1:0]RDATA;
`KEEP logic		[ID_WIDTH-1:0]RID;
`KEEP logic		RLAST;
`KEEP logic		RREADY;
`KEEP logic		[1:0]RRESP;
`KEEP logic		RVALID;
`KEEP logic		[DATA_WIDTH-1:0]WDATA;
`KEEP logic		WLAST;
`KEEP logic		WREADY;
`KEEP logic		[DATA_WIDTH/8-1:0]WSTRB;
`KEEP logic		WVALID;


//interconnect  -> S_AXI 
modport		slave
(
input			ACLK,
input			ARESETN,
input			ARADDR,
input			ARBURST,
input			ARCACHE,
input			ARID,
input			ARLEN,
input			ARLOCK,
input			ARPROT,
input			ARQOS,
output			ARREADY,
input			ARREGION,
input			ARSIZE,
input			ARVALID,

input			AWADDR,
input			AWBURST,
input			AWCACHE,
input			AWID,
input			AWLEN,
input			AWLOCK,
input			AWPROT,
input			AWQOS,
output			AWREADY,
input			AWREGION,
input			AWSIZE,
input			AWVALID,

output			BID,
input			BREADY,
output			BRESP,
output			BVALID,
output			RDATA,
output			RID,
output			RLAST,
input			RREADY,
output			RRESP,
output			RVALID,
input			WDATA,
input			WLAST,
output			WREADY,
input			WSTRB,
input			WVALID
);


//interconnect M_AXI -> connect
modport		master
(
input			ACLK,
input			ARESETN,
output			ARADDR,
output			ARBURST,
output			ARCACHE,
output			ARID,
output			ARLEN,
output			ARLOCK,
output			ARPROT,
output			ARQOS,
input			ARREADY,
output			ARREGION,
output			ARSIZE,
output			ARVALID,

output			AWADDR,
output			AWBURST,
output			AWCACHE,
output			AWID,
output			AWLEN,
output			AWLOCK,
output			AWPROT,
output			AWQOS,
input			AWREADY,
output			AWREGION,
output			AWSIZE,
output			AWVALID,

input			BID,
output			BREADY,
input			BRESP,
input			BVALID,
input			RDATA,
input			RID,
input			RLAST,
output			RREADY,
input			RRESP,
input			RVALID,
output			WDATA,
output			WLAST,
input			WREADY,
output			WSTRB,
output			WVALID
);

endinterface
