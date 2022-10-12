import cv2
import numpy
import importlib
import os

try:  ## check if a directory exist, if not create an output directory.
    os.mkdir("output")
except : pass 


## params:
RULES=["B3/S23","B3/S23","B3/S23","B3/S23","B2/S0","B2/S0"]
I=[0,115,0,568,0,50]
STARTING_POSITION=[5,5,4,4,6,6]
N=[21,21,100,100,25,25]

######################################################################################################
######################################################################################################
# Change the file name to your ID number !!!!!
File='ugash'
######################################################################################################
######################################################################################################

## import the py file:
Module = importlib.import_module(File)
Output = File
Output += "-test"
print(Output)


for j in range(len(I)):
    test_number=str(j+1)
    try:
        GOL = Module.GameOfLife(N[j], STARTING_POSITION[j], RULES[j])  
        for i in range(I[j]):
            GOL.update()
            board = GOL.return_board()
        board = GOL.return_board()
        GOL.save_board_to_file("output/OutImage" + str(test_number) + ".png")
		
        imge_test_path = "test/test" + test_number + ".png"
        image_test = cv2.imread(imge_test_path, cv2.IMREAD_GRAYSCALE)  
        (thresh, im_bw) = cv2.threshold(image_test, 128, 255, cv2.THRESH_BINARY | cv2.THRESH_OTSU)  # make a list from the test image.
        image_test_arr = numpy.array(im_bw)
        check1 = numpy.array_equal(image_test_arr, board)  # checks if the lists are equals
        image_test = cv2.imread(imge_test_path)
        image_output = cv2.imread("output/OutImage" + str(test_number) + ".png")
        image_test_arr = numpy.array(image_test)
        image_output_arr = numpy.array(image_output)
        check2 = numpy.array_equal(image_test_arr, image_output_arr)  # checks if the images are equals
        if check2&check1:
            print("Test number-", test_number, "pass")
        else:
            print("Test number-", test_number, "Failed:The board is the same?-",check1," The image is the same?-", check2)
    except Exception as e:  # if the code is crashing report it
        print("Test Number ",test_number,": crashed-", e)
