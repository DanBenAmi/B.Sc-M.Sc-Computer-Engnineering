Final Project
By: Dan Ben Ami and Tom Kessous

Sources files:

File: BoardSupport

	InitGPIO: GPIO ports Configuration - LEDs, LCD.

    InitTPM:TPM - Initialization

    ClockSetupTPM:TPMx - Clock Setup

	ClockSetup: defining the clock for the MCU and the timers.

	InitUARTs: initialize the UART registers set up.

	Uart0_Br_Sbr: Selection of BR (Baud Rate) and OSR (Over Sampling Ratio).

	uart_getchar: returns the char from the UART receiver.

	uart_putchar: transmit the char from the input through UART transmitter.

	UARTprintf: transmit the string from the input through UART transmitter.

	UARTprintf_arr: transmit the string from the input from the start index until stop index through UART transmitter.

	lcd_cmd: send a command to the LCD.

	lcd_data: send data to the LCD.

	lcd_puts: write a string of chars to the LCD.

	lcd_init: initialize the LCD.

	DelayUs:Delay usec functions.

	DelayMs: Delay msec functions.

	lcd_strobe: lcd strobe functions.

	dma0_init, dma1_init : initialize the DMA registers set up.

    InitPIT: PIT - Initialisation.


File: hal

    PIT_IRQHandler: PIT - ISR = Interrupt Service Routine

	PORTD_IRQHandler: PORTD - ISR = Interrupt Service Routine.

	UART0_IRQHandler: UART0 - ISR.

	DMA0_IRQHandler: DMA0 -ISR. 

	DMA1_IRQHandler: DMA1 -ISR.


File: main

	main: running the main code for the project.

	init: initialize all the GPIOs and components for the project.

    telemeter: enable the PIT to move to the right angle, calculate the average
     distance and send it to the pc.

    radar: Enable the PIT for the servo movement, sending synchronized data to the
     pc every 3 degrees about the current angle and distance.

    script: receiving scrupt files from the pc, sending the scripts list to the pc
     if needed, excecute a specific script that the pc asking. 

    display_files: displaying the script files list that saved in the MCU on the LCD.

    circular_logic: keep the files struct updated when memory buffer is full and need to be circular.

	run_over_logic: keep the files struct updated when the last file run over other files due to circular logic.

    get_file: receiving the file size and then the whole file throughthe DMA

    send_scripts_list: sending to the pc the script files list that in the MCU memory buffer.

    execute_script: receiving the script number to excecute and excecuting each instruction, one by one, from the script.

    decode_instruction: receivingthhe instruction and decode the opcode and operand, and excecute the right operation.

    lcd_count_up: count up from 0 to 10, operand times, and displaying on the LCD.

    lcd_count_down: count up from 10 to 0, operand times, and displaying on the LCD.

    servo_deg: Enable the PIT for the servo movement to the angle gotten from pc, and sending the distance to the pc.

    servo_scan: Enable the PIT for the servo movement from the right angle to the left angle,
    and sending the data (angle and distance) every 3 deggrees to the pc.

    
