# Name: Dan Ben Ami           ID:316333079
# Name: Tom Kessous           ID:206018749

import serial as ser
import time
import threading
import os

class serial_communicate:
    """class that containing all the variables and functions needed 
    for communication as an attibutes and methods."""
    def __init__(self):
        """initialize the class object, and attibutes as defualt."""
        self.s = ser.Serial('COM3', baudrate=9600, bytesize=ser.EIGHTBITS,
                   parity=ser.PARITY_NONE, stopbits=ser.STOPBITS_ONE,
                   timeout=1)   # timeout of 1 sec so that the read and write operations are blocking,
                                # after the timeout the program continues
        self.rx_data = ""
        self.rx_buffer = bytearray()
        self.tx_data = ""
        self.menu = None
        self.com='COM3'
        self.baud_rate=9600
        self.timeout=1

    def update_port(self,com,baudrate,timeout=1):
        """updating the port configuration"""
        self.s.close()
        self.timeout=timeout
        self.com = com
        self.baud_rate = int(baudrate)
        self.s = ser.Serial(self.com, baudrate= self.baud_rate, bytesize=ser.EIGHTBITS,
                            parity=ser.PARITY_NONE, stopbits=ser.STOPBITS_ONE,
                            timeout=timeout)  # timeout of 1 sec so that the read and write operations are blocking,
        # after the timeout the program continues

    def send_file(self,file_name,file):
        """sending file name, size and content to the pc"""
        self.tx_data = file_name
        time.sleep(0.5)
        content = file.read()
        self.tx_data =  str(len(content)+1)
        time.sleep(0.5)
        self.tx_data = content
        time.sleep(1)
        if self.rx_data == "Ack":
            return True
        return False



    def tx_msg(self):
        """method in to open in thread to keep transmitting whenever neeeded"""
        while self.s:
            if len(self.tx_data) > 0:
                bytesChar = bytes(self.tx_data+'\n', 'ascii')
                self.s.write(bytesChar)
                self.tx_data = ""
            else:
                time.sleep(0.4)

    def rx_msg(self):
        """method to open in thread to keep listening to messeges coming from PC"""
        while self.s:
            if self.s.in_waiting > 0:
                self.rx_buffer += self.s.read()
                if self.s.inWaiting() == 0:
                    self.rx_data = self.rx_buffer.decode("ascii")
                    self.rx_buffer = bytearray()
            else:
                time.sleep(0.4)







