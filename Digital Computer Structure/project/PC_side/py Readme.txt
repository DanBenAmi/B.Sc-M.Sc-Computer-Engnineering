Final Project
By: Dan Ben Ami and Tom Kessous

File: main
    running the main code of the pc side.

File: rec_trans
    file for the communication needs.

    class serial_communicate: class that containing all the variables and functions needed 
    for communication as an attibutes and methods.

        __init__: initialize the class object, and attibutes as defualt.

        update_port: updating the port configuration.

        send_file: sending file name, size and content to the pc.

        tx_msg: method to open in thread to keep transmitting whenever neeeded.

        rx_msg: method to open in thread to keep listening to messeges coming from PC.


File: gui
    file that responssible for all the graphical user interface.

    class GUI: class that holds all the variables and functions for the gui as attibutes and methods.

        __init__: initialize the class object, and attibutes as defualt.

        main_menu: keep the mainloop gui for the main menu.

        init_radar: start the radar mode mainloop.

        telemeter: keep the mainloop gui for the telemeter.

        receive_click: transmit the nedded angle and recieving messege from the pc of the distance, and display it.

        script: keep the mainloop gui for the script.

        open_file: try to open the file from the textentry, if succeed, try to send it to the MCU, write the results in the action_box.

        get_file_list: asking for the MCU to send the files list that saved in the MCU presenting the list in the text box.

        execute_script: sending the pc the key word "EX"+number of the file to execute.

        listening: keep listening to the recieving line to know what opcode gui to execute.

        op7: sending to the MCU the key word "scan" and starting radar in opcose 7 mode.


File: myradar:
    file that handeling the radar mode and the gui for it

    close_event: returning to the main menu

    start_radar: initialize the radar variables and containing the main loop for the radar updating and gui.


