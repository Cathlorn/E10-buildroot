/*
 * (C) Copyright 2004  Roman Avramenko <roman@imsystems.ru>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <memory.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <signal.h>

#include "gpio.h"

#ifdef DEBUG
#define DEBUGMSG(x, y, args...) if(x & DEBUG_LEVEL) printf(y, ##args)
#else
#define DEBUGMSG(x, y, args...)
#endif

#define PIOA_OFFSET 	0x400
#define PIOB_OFFSET 	0x600
#define PIOC_OFFSET 	0x800

#define PIOA_ID 	2
#define PIOB_ID 	3
#define PIOC_ID 	4

#define PMC_OFFSET	0xC00

int main(int argc, char *argv[])
{
	int fd, i, rc, pin, dest_addr, id, retval;
	char *current, action, port;
	void *map_base, *virt_addr; 
	unsigned long readval, writeval;
	
	if(argc < 2){
		DEBUGMSG(DEBUG_ERR, "AT91SAM9260 user-space GPIO control utility\n");
		DEBUGMSG(DEBUG_ERR, "(C) Copyright 2004 Roman Avramenko <roman@imsystems.ru>\n");
		DEBUGMSG(DEBUG_ERR, "Usage: gpio token1 token2 ... tokenN\n");
		DEBUGMSG(DEBUG_ERR, "Where token is: [action][port][pin],\n");
		DEBUGMSG(DEBUG_ERR, "and action is: [+] set or [-] clear or [?] check; port is: [PA,PB,PC]; pin is: [0..31]\n");
		DEBUGMSG(DEBUG_ERR, "Note: supported multiple set/clear and only one check request per each call\n");
		DEBUGMSG(DEBUG_ERR, "Examples: gpio +PB2 -PB3 [set PB2, clear PB3]\n");
		DEBUGMSG(DEBUG_ERR, "          gpio ?PB2 (return 0 if pin PB2 in 0 state, or 1 overwise)\n");
		exit(0);
	}

    	if((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1){
		DEBUGMSG(DEBUG_ERR, "gpio: Error opening /dev/mem\n");
		exit(-1);
	}
	
	for(i = 1; i < argc; i++){ /* Parse all given arguments */
		rc = 0;
		current = argv[i];
		action = current[0];
		if(action != '+' && action != '-' && action != '?') rc = -1;
		if(tolower(current[1]) != 'p') rc = -1;
		port = tolower(current[2]);
		if(port < 'a' || port > 'd') rc = -1;
		if(strlen(current) == 4){
			pin = current[3]-'0';
		} else if(strlen(current) == 5){
			pin = (current[3]-'0')*10 + (current[4]-'0');
		} else rc = -1;
		
		if(rc){
			DEBUGMSG(DEBUG_ERR, "gpio: Error in given argument '%s', skipping\n", current);
			continue;
		}
				
		/* Map one page */
		map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, AT91_SYS & ~MAP_MASK);
		if(map_base == (void *) -1){
			DEBUGMSG(DEBUG_ERR, "gpio: Error mapping memory\n");
			close(fd);
			exit(-1);
		}
		switch(port){
			case 'a': 
				dest_addr = PIOA_OFFSET;
				id = PIOA_ID;
				break;
			case 'b': 
				dest_addr = PIOB_OFFSET;
				id = PIOB_ID;
				break;
			case 'c': 
				dest_addr = PIOC_OFFSET;
				id = PIOC_ID;
				break;
		} 
			
		if(action != '?'){ /* Setup PIO registers */
			writeval = 1<< pin;
			*((unsigned long*)(map_base + ((dest_addr + PIO_PER) & MAP_MASK))) = writeval;
			*((unsigned long*)(map_base + ((dest_addr + PIO_OER) & MAP_MASK))) = writeval;
		}
		
		switch(action){
			case '+':
				*((unsigned long*)(map_base + ((dest_addr + PIO_SODR) & MAP_MASK))) = writeval;
				break;
			case '-':
				*((unsigned long*)(map_base + ((dest_addr + PIO_CODR) & MAP_MASK))) = writeval;
				break;
			case '?':
				/* First, enable PIO clock */
				writeval = 1 << id;
				*((unsigned long*)(map_base + ((PMC_OFFSET + PMC_PCER) & MAP_MASK))) = writeval;
				/* Then read port value */
				readval = *((unsigned long*)(map_base + ((dest_addr + PIO_PDSR) & MAP_MASK)));
				retval = (readval >> pin) & 0x00000001;
				printf("%x\n",retval);
				break;
		}

	}
	/* Unmap previously mapped page */
	if(munmap(map_base, MAP_SIZE) == -1){
		DEBUGMSG(DEBUG_ERR, "Error unmapping memory\n");
		close(fd);
		exit(-1);
	}
	
    close(fd);
	exit(retval);
}

