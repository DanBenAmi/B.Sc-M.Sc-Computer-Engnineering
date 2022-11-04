import serial.tools.list_ports
import tkinter as tk
from rec_trans import *
from tkinter import *
from myradar import *
import time
from PIL import Image,ImageTk
import threading
# import multiprocessing




class GUI:
    """class that holds all the variables and functions for the gui as attibutes and methods."""

    def __init__(self,siri):
        self.siri = siri
        self.curr_window = tk.Tk()
        self.op6_output_txtBox = None
        self.op7_bool = False
        self.right = ''

    def receive_click(self,textentry,mcu_txtBox):
        """transmit the nedded angle and recieving messege from the pc of the distance, and display it."""
        angle = textentry.get()
        self.siri.tx_data = angle
        mcu_txtBox.delete('1.0',END)
        self.siri.rx_data=''
        while len(self.siri.rx_data)==0:
            pass
        mcu_txtBox.insert(END, self.siri.rx_data +" cm")

    def telemeter(self):
        self.siri.tx_data = "2"
        self.curr_window.destroy()
        self.curr_window = tk.Tk()
        self.curr_window.configure(background="black")
        self.curr_window.title("Telemeter mode")
        photo = PhotoImage(file="telemeter.gif")
        Label(self.curr_window, image=photo, bg="black").grid(row=0, column=0, sticky=N)
        Label(self.curr_window, text="Telemeter mode", bg="black", fg="white", font="Ariel 20 bold").grid(row=1, column=0, sticky=N)
        Label(self.curr_window, text="Type an angle(0-180): ", bg="black", fg="white", font="Ariel 12 bold").grid(row=2, column=0, sticky=W)
        textentry = Entry(self.curr_window,width=32,bg="white")
        textentry.grid(row=2, column=0, sticky=E)
        Label(self.curr_window, text="\nDistance: ", bg="black", fg="white", font="Ariel 12 bold").grid(row=5, column=0, sticky=W)
        mcu_txtBox = Text(self.curr_window,width=50,height=2,wrap=WORD,background="white")
        mcu_txtBox.grid(row=6, column=0, columnspan=2, sticky=N)
        receive_button = tk.Button(self.curr_window, text="Receive", width=7, font='Arial 14', command=lambda: self.receive_click(textentry,mcu_txtBox)) .grid(row=7, column=0, sticky=N)

        Label(self.curr_window, text="\n\n", bg="black", fg="white", font="Ariel 12 bold").grid(row=8, column=0, sticky=W)
        back_button = tk.Button(self.curr_window, text="Back", width=5, font='Arial 14', command=lambda: self.main_menu()) .grid(row=10, column=0, sticky=N)
        Label (self.curr_window, text="\n",bg="black",fg = "white", font = "Ariel 20 bold") .grid(row=11, column=0, sticky=N)
        self.curr_window.mainloop()       

    def open_file(self,textentry, action_txtBox):
        """try to open the file from the textentry, if succeed, try to send it to the MCU, write the results in the action_box."""
        file_name = textentry.get()
        action_txtBox.delete('1.0', END)
        try:
            file = open("text_files/"+file_name)
            self.siri.send_file(file_name,file)
            action_txtBox.delete('1.0', END)
            action_txtBox.insert(END,"File "+file_name+" sent!")

        except:
            action_txtBox.insert(END, "File name is not in the library")

    def get_file_list(self, list_txtBox):
        """asking for the MCU to send the files list that saved in the MCU presenting the list in the text box."""
        self.siri.rx_data=''
        self.siri.tx_data = "RL"                         #RL=Receive List
        time.sleep(1)
        list_txtBox.delete('1.0', END)
        files_list = self.siri.rx_data
        files_num = int(files_list[0:1])
        s_idx = 2
        e_idx = 3
        for i in range(files_num):
            while (files_list[e_idx] != '\n'):
                e_idx +=1
            file_name = files_list[s_idx:e_idx+1]
            list_txtBox.insert(END, str(i+1)+")"+ file_name)
            s_idx = e_idx+1
            e_idx+=1

    def execute_script(self,textentry2):
        """sending the pc the key word "EX"+number of the file to execute."""
        script_num = textentry2.get()
        self.siri.rx_data=''
        self.siri.tx_data = "EX"+script_num            # EX = execute


    def listening(self):
        """keep listening to the recieving line to know what opcode gui to execute."""
        data=''
        while 1:
            data = self.siri.rx_data
            if(data=="op6"):
                self.siri.rx_data=''
                while(self.siri.rx_data ==''):
                    time.sleep(0.0001)
                angle_dist = self.siri.rx_data
                angle_dist = angle_dist.split(',')
                angle, dist = angle_dist[0], angle_dist[1]
                self.op6_output_txtBox.delete('1.0',END)
                self.op6_output_txtBox.insert(END,"angle: "+angle+" degrees       distance: "+dist+"cm")
            elif(data[:3]=="op7"):
                self.right = data[3:]
                self.siri.rx_data = ''
                self.op7_bool = True
            else:
                time.sleep(0.0001)


    def script(self):
        """keep the mainloop gui for the script."""
        self.siri.tx_data = "3"
        self.curr_window.destroy()
        self.curr_window = tk.Tk()
        self.curr_window.configure(background="black")
        self.curr_window.title("Script mode")
        photo = PhotoImage(file="script.gif")
        Label(self.curr_window, image=photo, bg="black").grid(row=0, column=0, sticky=N)
        Label(self.curr_window, text="Script mode", bg="black", fg="white", font="Ariel 20 bold").grid(row=1, column=0, sticky=N)
        Label(self.curr_window, text="Script name to send: ", bg="black", fg="white", font="Ariel 12 bold").grid(row=2, column=0, sticky=W)
        textentry = Entry(self.curr_window, width=30, bg="white")
        textentry.grid(row=2, column=0, sticky=E)

        send_file_button = tk.Button(self.curr_window, text="Send", width=5, font='Arial 14',
                                command=lambda: self.open_file(textentry, action_txtBox)).grid(row=4, column=0, sticky=N)
        Label(self.curr_window, text="Actions: ", bg="black", fg="white", font="Ariel 12 bold").grid(row=5, column=0, sticky=W)
        action_txtBox = Text(self.curr_window, width=50, height=2, wrap=WORD, background="grey")
        action_txtBox.grid(row=6, column=0, columnspan=2, sticky=N)
        list_txtBox = Text(self.curr_window, width=50, height=4, wrap=WORD, background="grey")
        list_txtBox.grid(row=9, column=0, columnspan=2, sticky=N)
        list_file_button = tk.Button(self.curr_window, text="Get scripts list", width=15, font='Arial 14',
                                     command=lambda: self.get_file_list(list_txtBox)).grid(row=8, column=0,sticky=N)


        Label(self.curr_window, text="Script number to execute: ", bg="black", fg="white", font="Ariel 12 bold").grid(row=10, column=0,sticky=W)
        textentry2 = Entry(self.curr_window, width=15, bg="white")
        textentry2.grid(row=10, column=0, sticky=E)
        self.op6_output_txtBox = Text(self.curr_window, width=50, height=2, wrap=WORD, background="grey")
        self.op6_output_txtBox.grid(row=13, column=0, columnspan=2, sticky=N)
        execute_script_button = tk.Button(self.curr_window, text="Execute", width=7, font='Arial 14',
                                     command=lambda: self.execute_script(textentry2)).grid(row=11, column=0,sticky=N)
        Label(self.curr_window, text="Actions: ", bg="black", fg="white", font="Ariel 12 bold").grid(row=12, column=0, sticky=W)

        Label(self.curr_window, text="\n\n", bg="black", fg="white", font="Ariel 12 bold").grid(row=15, column=0, sticky=W)

        threading.Thread(target=self.listening).start()
        # multiprocessing.Process(None, self.listening).start()
        back_button = tk.Button(self.curr_window, text="Back", width=5, font='Arial 14',
                                command=lambda: self.main_menu()).grid(row=16, column=0, sticky=N)
        Label (self.curr_window, text="\n",bg="black",fg = "white", font = "Ariel 20 bold") .grid(row=17, column=0, sticky=N)

        self.curr_window.after(500, self.op7)

        self.curr_window.mainloop()

    def op7(self):
        """sending to the MCU the key word "scan" and starting radar in opcose 7 mode"""
        if self.op7_bool:
            self.siri.tx_data = "scan"
            time.sleep(0.4)
            start_radar(self.siri, "op7", int(self.right))
            self.op7_bool = False
            self.siri.tx_data = "7Done"
            time.sleep(0.4)
            self.curr_window.after(500, self.op7)
        else:
            self.curr_window.after(500, self.op7)



    def init_radar(self):
        """start the radar mode mainloop."""
        start_radar(self.siri,"radar")
        self.siri.tx_data = "4"
        return


    def main_menu(self):
        """keep the mainloop gui for the main menu."""
        self.curr_window.destroy()
        self.curr_window = tk.Tk()
        self.curr_window.configure(background="black")
        self.curr_window.title("Final Project")
        photo = PhotoImage(file="menu.gif")
        Label (self.curr_window,image=photo,bg="black") .grid(row=0, column=0, sticky=W)
        Label (self.curr_window, text="Final Project 2021",bg="black",fg = "white", font = "Ariel 20 bold") .grid(row=1, column=0, sticky=N)
        Label (self.curr_window, text="By: Dan&Tom\n\nMenu:",bg="black",fg = "white", font = "Ariel 16 bold") .grid(row=2, column=0, sticky=N)
        a_button = Button(self.curr_window, text="Radar", width=14, font='Arial 16', command=lambda: self.init_radar()) .grid(row=4, column=0, sticky=N)
        b_button = Button(self.curr_window, text="Telemeter", width=14, font='Arial 16', command=lambda: self.telemeter()) .grid(row=6, column=0, sticky=N)
        c_button = Button(self.curr_window, text="Script", width=14, font='Arial 16', command=lambda: self.script()) .grid(row=7, column=0, sticky=N)
        # siri.tx_data = "4"
        Label (self.curr_window, text="\n",bg="black",fg = "white", font = "Ariel 20 bold") .grid(row=8, column=0, sticky=N)
        self.curr_window.mainloop()







