#ifndef SRC_MAIN_H_
#define SRC_MAIN_H_

#define BRAM_WRITE_BASE_ADDRESS XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define BRAM_READ_BASE_ADDRESS  XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 4*(0x800)

#define CLK_DIV_BAUD 	((u32*) (BRAM_WRITE_BASE_ADDRESS + 4*(0x00)))
#define TX_BUF_DATA 	((u32*) (BRAM_WRITE_BASE_ADDRESS + 4*(0x01)))
#define LEDS		 	((u32*) (BRAM_WRITE_BASE_ADDRESS + 4*(0x02)))
#define SEVEN_SEGW		((u32*) (BRAM_WRITE_BASE_ADDRESS + 4*(0x03)))

#define RX_BUF_EMTY 	((u32*) (BRAM_READ_BASE_ADDRESS + 4*(0x00)))
#define RX_BUF_DATA 	((u32*) (BRAM_READ_BASE_ADDRESS + 4*(0x01)))
#define TX_BUF_FULL 	((u32*) (BRAM_READ_BASE_ADDRESS + 4*(0x02)))

#endif
