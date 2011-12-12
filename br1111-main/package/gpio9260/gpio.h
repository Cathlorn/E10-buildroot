#ifndef GPIO_H
#define GPIO_H

/* Debug constants */
#define DEBUG_FRAME		0x0001
#define DEBUG_STATUS 		0x0002
#define DEBUG_FIELD		0x0004
#define DEBUG_ERR		0x0008
#define DEBUG_TIME		0x0010
#define DEBUG_INIT		0x0020

/* Debug settings */
#define DEBUG
#define DEBUG_ALL		(DEBUG_STATUS | DEBUG_ERR)
#define DEBUG_LEVEL		DEBUG_ALL

/* Memory mapping definitions */
#define MAP_SIZE 4096UL
#define MAP_MASK (MAP_SIZE - 1)

/* AT91SAM9260 PIO definitions */
#define AT91_SYS	0xFFFFF000
#define AT91_PIOA	0xFFFFF400
#define AT91_PIOB	0xFFFFF600
#define AT91_PIOC	0xFFFFF800

#define PMC_PCER	0x0010

#define PIO_PER		0x0000
#define PIO_PDR		0x0004
#define PIO_OER		0x0010
#define PIO_ODR		0x0014
#define PIO_SODR	0x0030
#define PIO_CODR	0x0034
#define PIO_PDSR	0x003c

#endif

