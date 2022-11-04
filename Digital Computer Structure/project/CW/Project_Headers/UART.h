#ifndef TFC_UART_H_
#define TFC_UART_H_

void Uart0_Br_Sbr(int sysclk, int baud);
void InitUARTs(int baudrate);
void UART0_IRQHandler();
char uart_getchar (UART_MemMapPtr channel);
void uart_putchar (UART_MemMapPtr channel, char ch);
void UARTprintf(UART_MemMapPtr channel,char* str);
void UARTprintf_arr(UART_MemMapPtr channel,char* arr,int start,int stop);
#endif /* TFC_UART_H_ */
