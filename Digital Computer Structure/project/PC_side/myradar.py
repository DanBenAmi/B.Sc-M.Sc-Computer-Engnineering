# Python + Arduino-based Radar Plotter
#
# ** Works with any motor that outputs angular rotation
# ** and with any distance sensor (HC-SR04, VL53L0x,LIDAR)
#
import myradar
import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from matplotlib.widgets import Button as btn
from matplotlib.widgets import TextBox
import sys, glob
import time

############################################
# button event to stop program
############################################
back_bool = False


# button to close window
def close_event(event):
    global back_bool
    back_bool = True

############################################
# Start the interactive plotting tool and
# plot 180 degrees with dummy data to start
############################################
#
def start_radar(siri,mode,right=180):
    """initialize the radar variables and containing the main loop for the radar updating and gui."""
    fig = plt.figure(facecolor='k')
    start_word = True
    global back_bool
    back_bool = False
    win = fig.canvas.manager.window  # figure window
    screen_res = win.wm_maxsize()  # used for window formatting later
    dpi = 100.0  # figure resolution
    fig.set_dpi(dpi)  # set figure resolution

    # polar plot attributes and initial conditions
    ax = fig.add_subplot(111, polar=True, facecolor='g')
    ax.set_position([-0.05, -0.05, 1.1, 1.05])
    r_max = 50.0  # can change this based on range of sensor
    ax.set_ylim([0.0, r_max])  # range of distances to show
    ax.set_xlim([0.0, np.pi])  # limited by the servo span (0-180 deg)
    ax.tick_params(axis='both', colors='w')
    ax.grid(color='w', alpha=0.5)  # grid color
    ax.set_rticks(np.linspace(0.0, r_max, 5))  # show 5 different distances
    ax.set_thetagrids(np.linspace(0.0, 180.0, 10))  # show 10 angles
    angles = np.arange(0, 181, 1)  # 0 - 180 degrees
    theta = angles * (np.pi / 180.0)  # to radians
    dists = np.ones((len(angles),))  # dummy distances until real data comes in
    pols, = ax.plot([], linestyle='', marker='o', markerfacecolor='w',
                    markeredgecolor='#EFEFEF', markeredgewidth=1.0,
                    markersize=10.0, alpha=0.9)  # dots for radar points
    line1, = ax.plot([], color='w',
                     linewidth=4.0)  # sweeping arm plot

    # figure presentation adjustments
    fig.set_size_inches(0.96 * (screen_res[0] / dpi), 0.96 * (screen_res[1] / dpi))
    plot_res = fig.get_window_extent().bounds  # window extent for centering
    win.wm_geometry('+{0:1.0f}+{1:1.0f}'. \
                    format((screen_res[0] / 2.0) - (plot_res[2] / 2.0),
                           (screen_res[1] / 2.0) - (plot_res[3] / 2.0)))  # centering plot
    fig.canvas.toolbar.pack_forget()  # remove toolbar for clean presentation

    fig.canvas.draw()  # draw before loop
    axbackground = fig.canvas.copy_from_bbox(ax.bbox)  # background to keep during loop

    close_ax = fig.add_axes([0.025, 0.025, 0.125, 0.05])
    close_but = btn(close_ax, 'Back', color='#FCFCFC', hovercolor='w')
    close_but.on_clicked(close_event)


    axbox_angle = fig.add_axes([0.55, 0.1, 0.08, 0.05])
    text_box_angle = TextBox(axbox_angle, "Angle: ",color='black')
    text_box_angle.label.set_color('white')  # label color
    text_box_angle.text_disp.set_color('white')  # text inside the edit box
    text_box_angle.set_val('0')

    axbox_dist = fig.add_axes([0.7, 0.1, 0.08, 0.05])
    text_box_dist = TextBox(axbox_dist, "Distance: ", color='black')
    text_box_dist.label.set_color('white')  # label color
    text_box_dist.text_disp.set_color('white')  # text inside the edit box
    text_box_dist.set_val('0')




    fig.show()
    siri.rx_data = ''
    all_data = "0,0"
    siri.tx_data = "1"
    prev_angle=0
    angle=0
    one_time_flag = True
    prev_data=''
    while True:
        time.sleep(0.01)
        if back_bool:  # stops program
            fig.canvas.toolbar.pack_configure()  # show toolbar
            plt.close('all')
            time.sleep(0.1)
            return
        if (mode == "op7" and angle >= right):
            if one_time_flag:
                siri.tx_data = "3"
                time.sleep(2)
                back_bool = True
                one_time_flag = False
                all_data = prev_data + ","
        else:
            all_data += siri.rx_data
        data = ''
        if len(all_data) > 2 :
            siri.rx_data=''
            all_data_list = all_data.split(',')
            if (all_data_list[0] == '' or abs(int(all_data_list[0])-prev_angle) != 3) and one_time_flag:
                all_data_list=all_data_list[1:]
            print(all_data_list)
            data = all_data_list[:2]
            prev_data=','.join(data)
            all_data_list = all_data_list[2:]
        if len(data) != 2 or data[1]=='':
            continue
        else:
            all_data = ','.join(all_data_list)
            vals = [float(ii) for ii in data]
            siri.rx_data = ''
            angle, dist = vals  # separate into angle and distance
            prev_angle = angle
            if dist > r_max:
                dist = 0.0  # measuring more than r_max, it's likely inaccurate
            dists[int(angle)] = dist
            if angle:  # update every 5 degrees
                print("angle: ", angle)
                print("dist: ", dist)


                pols.set_data(theta, dists)
                fig.canvas.restore_region(axbackground)
                ax.draw_artist(pols)

                line1.set_data(np.repeat((angle * (np.pi / 180.0)), 2),
                               np.linspace(0.0, r_max, 2))
                ax.draw_artist(line1)
                fig.canvas.blit(ax.bbox)  # replot only data
                text_box_angle.set_val(angle)
                text_box_dist.set_val(dist)
                fig.canvas.flush_events()  # flush for next plot

