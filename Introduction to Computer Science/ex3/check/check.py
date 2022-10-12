import importlib
import  os



dir_name = os.path.dirname(__file__) + '/test/'

expected_file_size = {'bible.txt': [2197102, 2703027, 4.342751389250246],
                      'Lipsum.txt': [841, 1040, 4.241712851968036],
                      'pic.bin': [77635, 141788, 1.2101759413586748],
                      'geo.bin': [72274, 85075, 5.646375764301419]}

######################################################################################################
######################################################################################################
# Change the file name to your ID number !!!!!
File='YOUR_ID'
######################################################################################################
######################################################################################################
test_number = 1;



###  txt files tests
files_list = ['bible.txt', 'Lipsum.txt']



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

for original_fname in files_list:
    try:
        h = Module.HuffmanCoding(dir_name + original_fname)
        decompressed_fname = h.decompress_file(h.compressed_file_path)
        with open(dir_name + original_fname, 'rt') as f1, open(decompressed_fname, 'rt') as f2:
            data1 = f1.read()
            data2 = f2.read()
            f1.close()
            f2.close()
        print("Test number-", test_number,"Source size equal to decompressed size:", data1 == data2)
        test_number += 1
    except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1
    try:
        print("Test number-", test_number,"The compress file size range is correct:", expected_file_size[original_fname][0] <
            os.path.getsize(h.compressed_file_path) <
            expected_file_size[original_fname][1])
        test_number += 1
    except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1
    try:
        print("Test number-", test_number + 2, "The entropy range is correct:",
              expected_file_size[original_fname][2]*0.9 <
              h.calculate_entropy() <
              expected_file_size[original_fname][2]*1.1)
        test_number += 1
    except Exception as e:
        print("Test Number ",test_number,": crashed-", e)
        test_number += 1



###  bin files tests
files_list = ['pic.bin', 'geo.bin']

for original_fname in files_list:
    try:
        h = Module.HuffmanCoding(dir_name + original_fname)
        decompressed_fname = h.decompress_file(h.compressed_file_path)
        with open(dir_name + original_fname, 'rb') as f1, open(decompressed_fname, 'rb') as f2:
            data1 = f1.read()
            data2 = f2.read()
            f1.close()
            f2.close()
        print("Test number-", test_number,"Source size equal to decompressed size:", data1 == data2)
        test_number += 1
    except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1
    try:
        print("Test number-", test_number+1,"The compress file size range is correct:", expected_file_size[original_fname][0] <
            os.path.getsize(h.compressed_file_path) <
            expected_file_size[original_fname][1])
        test_number += 1
    except Exception as e:
        print("Test Number ", test_number, ": crashed-", e)
        test_number += 1
    try:
        print("Test number-", test_number, "The entropy range is correct:",
              expected_file_size[original_fname][2] * 0.9 <
              h.calculate_entropy() <
              expected_file_size[original_fname][2] * 1.1)
        test_number += 1
    except Exception as e:
        print("Test Number ",test_number,": crashed-", e)
        test_number += 1

