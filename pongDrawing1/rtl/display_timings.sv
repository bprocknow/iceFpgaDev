
`ifdef SIMULATED
// Horizonal display timing parameters
localparam HA_ACTIVE_PIX = 640;
//localparam HA_ACTIVE_PIX = 20;
localparam HA_FRONT_PORCH = 1;
localparam HA_SYNC_WIDTH = 0;
localparam HA_BACK_PORCH = 1;
/* verilator lint_off UNUSEDPARAM */
localparam HA_TOTAL_PIX = (HA_ACTIVE_PIX + HA_FRONT_PORCH + HA_SYNC_WIDTH + HA_BACK_PORCH);

// Vertical display timing parameters
localparam VA_ACTIVE_PIX = 480;
//localparam VA_ACTIVE_PIX = 20;
localparam VA_FRONT_PORCH = 0;
localparam VA_SYNC_WIDTH = 1;
localparam VA_BACK_PORCH = 1;
localparam VA_TOTAL_PIX = (VA_ACTIVE_PIX + VA_FRONT_PORCH + VA_SYNC_WIDTH + VA_BACK_PORCH);
`else
// Horizonal display timing parameters
localparam HA_ACTIVE_PIX = 640;
localparam HA_FRONT_PORCH = 16;
localparam HA_SYNC_WIDTH = 96;
localparam HA_BACK_PORCH = 48;
/* verilator lint_off UNUSEDPARAM */
localparam HA_TOTAL_PIX = (HA_ACTIVE_PIX + HA_FRONT_PORCH + HA_SYNC_WIDTH + HA_BACK_PORCH);

// Vertical display timing parameters
localparam VA_ACTIVE_PIX = 480;
localparam VA_FRONT_PORCH = 10;
localparam VA_SYNC_WIDTH = 2;
localparam VA_BACK_PORCH = 33;
/* verilator lint_off UNUSEDPARAM */
localparam VA_TOTAL_PIX = (VA_ACTIVE_PIX + VA_FRONT_PORCH + VA_SYNC_WIDTH + VA_BACK_PORCH);
`endif
