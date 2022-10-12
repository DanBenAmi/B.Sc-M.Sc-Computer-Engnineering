import csv
import importlib
import os
import numpy as np



dir_name = os.path.dirname(__file__) + '/test/'



######################################################################################################
######################################################################################################
# Change the file name to your ID number !!!!!
File='316333079'
######################################################################################################
######################################################################################################
test_number = 1;

### import the py file
try:
    Module = importlib.import_module(File)
    Output = File
    Output += "-test"
    print(Output)
except Exception as e:
    print("crashed:", e)
    exit(1)

### Pre-test-filename is valid
if ((not(File.isdigit()) or len(File)!=9) and File!="sample" ):
    print("File name is invalid !!!!!!!!")

#test number 1

map_size = (30, 30)
mines = np.zeros(map_size).tolist()
mines[16][6] = 1
mines[12][4] = 1
mines[14][10] = 1
mines[17][11] = 1
velocity = list()
velocity.append([1, 1])
sonar_range = 6
sonar_angle = 15
initial_position = (14, 1)
duration = [8]
try:
    game1 = Module.HydroCamel(sonar_range, sonar_angle, map_size, initial_position, velocity, duration, mines)
    try:
        for i in range(0, 7):
            try:
                game1.time_step()
            except Exception as e:
                print("Test Number", test_number, "time step fails")
                break
#get mines test
            test_ok=True
            output = []
            try:
                get_mines=game1.get_mines()
            except Exception as e:
                print("Test Number", test_number, "get mines fails")
                break
            with open(dir_name + str(i) +'_get_mines1.txt') as in_file:
                output = in_file.read().splitlines()
                if len(output) != len(get_mines):
                    test_ok = False
                    count = 0
                    print("Test Number", test_number, "get mines ", ": fails mumber of points discovered",
                          get_mines.len(), "The correct number of points", output.len())
                for j in output:
                    text = j.split(' ')
                    point = (int(text[0]), int(text[1]))
                    try:
                        if not (point == get_mines[count]):
                            test_ok = False
                            print("Test Number", test_number, "get mines ", ": fails", j, "not discovered")
                    except Exception as e:
                        test_ok=False
                        print("Test Number", test_number, "get mines in step", i, ": fails", j, "not discovered")
                    count+=1
            if test_ok:
                print("Test Number", test_number,"get mines in step",i,": pass")
# get sonar fov test
            test_ok = True
            output = []
            try:
                get_sonar_fov = game1.get_sonar_fov()
            except Exception as e:
                print("Test Number", test_number, "get sonar fov fails")
                break
            with open(dir_name + str(i) + '_get_sonar_fov1.txt') as in_file:
                output=in_file.read().splitlines()
            for j in output:
                text = j.split(' ')
                point=(int(text[0]),int(text[1]))
                try:
                    is_discovered=get_sonar_fov.get(point)
                    if is_discovered == None:
                        test_ok = False
                        print("Test Number", test_number, "get mines ", ": fails", j, "not discovered")
                except Exception as e:
                    test_ok = False
                    print("Test Number", test_number, "get sonar fov in step", i, ": fails", j, "not discovered")
            if test_ok:
                print("Test Number", test_number, "get sonar fov in step", i, ": pass")

    except Exception as e:
        print("Test Number", test_number, "Fails")


except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1


#test number 2

test_number += 1

try:
    sonar_range = 5
    sonar_angle = 30
    map_size = (30, 30)
    initial_position = (15, 10)
    velocity = list()
    velocity.append([2, 2])
    velocity.append([-2, -2])
    velocity.append([0, 2])
    velocity.append([2, 0])
    velocity.append([2, 0])
    velocity.append([0, 2])
    velocity.append([-2, 0])
    velocity.append([0, -2])
    duration = [2, 2, 2, 2, 2, 2, 2, 3]
    mines = np.loadtxt(dir_name+"mines2.txt", dtype=int)
    mines =mines.tolist()
    game2 = Module.HydroCamel(sonar_range, sonar_angle, map_size, initial_position, velocity, duration, mines)
    try:
        game2.time_step()
    except Exception as e:
        print("Test Number", test_number, "time step method fails")
    try:
        game2.start()
    except Exception as e:
        print("Test Number", test_number, "time start method fails")
    # get mines test
    test_ok = True
    output = []
    try:
        get_mines = game2.get_mines()
    except Exception as e:
        print("Test Number", test_number, "get mines Fails")
    with open(dir_name + 'get_mines2.txt') as in_file:
        output = in_file.read().splitlines()
        count = 0
        if len(output)!=len(get_mines):
            test_ok = False
            print("Test Number", test_number, "get mines ", ": fails mumber of points discovered", get_mines.len(), "The correct number of points",output.len())
        for j in output:
            text = j.split(' ')
            point = (int(text[0]), int(text[1]))
            try:
                if not(point == get_mines[count]):
                    test_ok = False
                    print("Test Number", test_number, "get mines ", ": fails", j, "not discovered")
            except Exception as e:
                test_ok = False
                print("Test Number", test_number, "get mines ", ": fails", j, "not discovered")
            count+=1
    if test_ok:
        print("Test Number", test_number, "get mines ", ": pass")
    # get sonar fov test
    test_ok = True
    output = []
    try:
        get_sonar_fov = game2.get_sonar_fov()
    except Exception as e:
        print("Test Number", test_number, "get sonar fov Fails")
    with open(dir_name + 'get_sonar_fov2.txt') as in_file:
        output = in_file.read().splitlines()
    for j in output:
        text = j.split(' ')
        point = (int(text[0]), int(text[1]))
        try:
            is_discovered=get_sonar_fov.get(point)
            if is_discovered == None:
                test_ok = False
                print("Test Number", test_number, "get mines ", ": fails", j, "not discovered")
        except Exception as e:
            test_ok = False
            print("Test Number", test_number, "get sonar fov ", ": fails", j, "not discovered")
    if test_ok:
        print("Test Number", test_number, "get sonar fov ", ": pass")
    try:
        henadin=game2.get_heading()
        if henadin==180.0:
            print("Test Number", test_number, "get heading", ": pass")
        else:
            print("Test Number", test_number, "get heading", ": fails")

    except Exception as e:
        print("Test Number", test_number, "time get henading method fails")


except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1
