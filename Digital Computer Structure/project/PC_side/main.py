import time

from gui import *
from rec_trans import *
import threading


if __name__ == '__main__':
    siri = serial_communicate()
    threading.Thread(target=siri.tx_msg).start()
    threading.Thread(target=siri.rx_msg).start()
    gui = GUI(siri)
    gui.main_menu()

