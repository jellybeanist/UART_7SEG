#include "main.h"
#include <stdio.h>
#include <sleep.h>
#include <inttypes.h>
#include <stdint.h>
u32 temp=0;
u32 adder=0;
u32 right=0;
u32 shift=0;
u32 sent=0;
int main (void)
{
	CLK_DIV_BAUD[0] = 100000000/115200;
	sleep(1);
	int i=0;
	while (1)
	{

		if(RX_BUF_EMTY[0] == 0){
			TX_BUF_DATA[0] = RX_BUF_DATA[0];


			temp = RX_BUF_DATA[0];
			SEVEN_SEGW[0] = shift+RX_BUF_DATA[0];

			}
		shift = temp<<8;
		}
	return 0;
	}

