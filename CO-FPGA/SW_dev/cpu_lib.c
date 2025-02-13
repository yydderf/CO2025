#include <stdarg.h>
#include "cpu_lib.h"


#ifdef DEBUG_SIM
    #define UART_STALL_NUM 2
#else
    #define UART_STALL_NUM 1600
#endif
// 1600 for 20MHz cpu clock / 115200 BAUD.


extern int main(void);

volatile unsigned int __stack_top = 0x00000CA0;

volatile unsigned int * uart_tx       = (volatile unsigned int *)0xA0000000;
volatile unsigned int * uart_rx_data  = (volatile unsigned int *)0xA0000001;
volatile unsigned int * uart_rx_stat  = (volatile unsigned int *)0xA0000002;
volatile unsigned int * uart_rx_ack   = (volatile unsigned int *)0xA0000003;
volatile unsigned int * sevseg_stat   = (volatile unsigned int *)0xB0000000;
volatile unsigned int * sevseg_lwtst0 = (volatile unsigned int *)0xBCafe427;
volatile unsigned int * sevseg_lwtst1 = (volatile unsigned int *)0xBeefDead;
volatile unsigned int * sevseg_lwtst2 = (volatile unsigned int *)0xB0EC6190;
volatile unsigned int * sevseg_lwtst3 = (volatile unsigned int *)0xBFFFFFFF;


__attribute__((section(".text.init"))) 
void init(void)
{
    // for self-checking
    *sevseg_lwtst0 = 0xbCafe427;
    *sevseg_lwtst1 = 0xBeefDead;
    *sevseg_lwtst2 = 0xb0EC6190;
    *sevseg_lwtst3 = 0xbFFFFFFF;

    __asm__ volatile("li  sp, 0");
    __asm__ volatile("lw  sp, %lo(__stack_top)(x0)");
    volatile int _main_ret = main();
    exit(_main_ret);
}


int putchar(int c)
{
    if (c == '\n')
    {
        while (*uart_tx == 0);
        *uart_tx = (unsigned char) '\r';
    }
    while (*uart_tx == 0);
    *uart_tx = (unsigned char) c;
    return 0;
}


#pragma GCC push_options
// The default optimization flag set in Makefile is "-O2", 
// one may try the flag here to stop compiler from generating
// unwanted or unsupported instructions.
#pragma GCC optimize ("O2")

// The lame-looking code below is a tug-of-war with the compiler to stop it from using
// "mul", "div" and other instructions that are not supported by the lab CPU.
int __putdNonDiv(int value)
{
    if (value == 0) 
    {
        putchar('0');
        return 0;
    }
    if (value > 100000000) return 0;

    int pwr_ten_arr[10]; 
    pwr_ten_arr[0] = 1;         pwr_ten_arr[1] = 10;       
    pwr_ten_arr[2] = 100;       pwr_ten_arr[3] = 1000;      
    pwr_ten_arr[4] = 10000;     pwr_ten_arr[5] = 100000;  
    pwr_ten_arr[6] = 1000000;   pwr_ten_arr[7] = 10000000;  
    pwr_ten_arr[8] = 100000000; pwr_ten_arr[9] = 1000000000;

    int max_pwr_idx = 9;
    while (pwr_ten_arr[max_pwr_idx] > value) 
    {
        max_pwr_idx--;
    }
    for (int i = max_pwr_idx; i > 0; --i) 
    {
        
        int digit = 48;
        while (pwr_ten_arr[i] < value) 
        {
            value -= pwr_ten_arr[i];
            digit++;
        }
        if (pwr_ten_arr[i] == value)
        {
            value -= pwr_ten_arr[i];
            digit++;
        }
        if (digit != 48 || i <= max_pwr_idx) 
        {
            putchar(digit);
        }
    }
    int digit = 48;
    if (value == 0)
    {
        putchar(digit);
        return 0;
    }
    while (1 < value) 
    {
        value -= 1;
        digit++;
    }
    digit++;
    putchar(digit);
    return 0;
}
#pragma GCC pop_options


int printf(char* fmt, ...) 
{
    va_list list;
    for (va_start(list, fmt); *fmt; fmt++) 
    {
        if (*fmt == '%') 
        {
            fmt++;
            if (*fmt == 'd')
            {
                __putdNonDiv(va_arg(list, int));
            }
            else if (*fmt == 'c')
            {
                putchar(va_arg(list, int));
            }
            else
            {
                /* Exit on any other format specifier */
                return -1;
            }
        }
        else
        {
            putchar(*fmt);
        }
    }
    
    va_end(list);
    return 0;
}


int getchar(void)
{
    while (*uart_rx_stat == 0);
    int uart_rx_data_r = *uart_rx_data;
    *uart_rx_ack = 1;
    return uart_rx_data_r;
}


void exit(int status)
{
    printf("PROGRAM EXITED WITH CODE %d.\n", status);
    *sevseg_stat = 2;
    while (1)
    {
        __asm__ volatile ("NOP");
    }
}
