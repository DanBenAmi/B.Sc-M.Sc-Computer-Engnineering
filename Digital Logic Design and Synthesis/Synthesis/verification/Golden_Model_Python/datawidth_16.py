import numpy as np
import random

H2_encode = np.array([
    [1]*11,
    [1]*7+[0]*4,
    [1]*4+[0]*3+[1]*3+[0],
    [1,1,0,0]+[1,1,0]*2+[1],
    [1,0]*3+[1,1,0,1,1]
    ])
H1_encode = np.array([
    [1]*4,
    [1,1,1,0],
    [1,1,0,1],
    [1,0,1,1]
])

H = [H1_encode,H2_encode]
def flip_bit(vec, index):
    if vec[index] == 0:
        vec[index] = 1
    else:
        vec[index] = 0

def calculate_parity(inp):
    length = Data_width-data_in_width
    parity = np.array([0]*length)
    for j in range(length-1,-1,-1):
        parity[j] = H[data_mode][j]@inp % 2
    for j in range(length-1,0,-1):
        parity[0] += parity[j]
    parity[0] = parity[0] % 2
    return parity

def make_encode_files():
    #encoding
    f_encoder_in = open("golden_model_inputs_0"+str(data_mode)+".txt","wt")
    f_encoder_out = open("golden_model_outputs_0"+str(data_mode)+".txt","wt")
    form = "{0:0" + str(data_in_width) + "b}"
    for i in range(2**data_in_width):
        inp = form.format(i)
        f_encoder_in.write(inp+'\n')
        inp = np.array([int(x) for x in inp])
        out  = np.concatenate((inp,calculate_parity(inp)))
        out = ''.join(str(e) for e in out)
        f_encoder_out.write(out+'\n')
    f_encoder_in.close()
    f_encoder_out.close()

def make_decode_files():
    #decode files
    f_decoder_in = open("golden_model_inputs_1"+str(data_mode)+".txt","wt")
    f_decoder_out = open("golden_model_outputs_1"+str(data_mode)+".txt","wt")
    f_encoder_in = open("golden_model_inputs_0"+str(data_mode)+".txt", "rt")
    f_encoder_out = open("golden_model_outputs_0"+str(data_mode)+".txt", "rt")
    form = "{0:0" + str(Data_width) + "b}"
    lines = f_encoder_out.readlines()
    for i in range(len(lines)):
        line = lines[i][:-1]
        vec = np.array([int(x) for x in line])
        if i%3 == 0:
            f_decoder_in.write(line+'\n')
        elif i%3 == 1:
            index = random.choice(range(Data_width))
            flip_bit(vec,index)
            f_decoder_in.write(''.join(str(e) for e in vec)+'\n')
        else:
            indexes = random.sample(range(Data_width),2)
            flip_bit(vec,indexes[0])
            flip_bit(vec,indexes[1])
            f_decoder_in.write(''.join(str(e) for e in vec)+'\n')
    lines = f_encoder_in.readlines()
    for i in range(len(lines)):
        f_decoder_out.write(lines[i][:-1]+' '+str(i%3)+'\n')
    f_decoder_out.close()
    f_decoder_in.close()
    f_encoder_out.close()
    f_encoder_in.close()

def make_noise_file():
    #noise files
    f_noise = open("noise_"+str(data_mode)+".txt","wt")
    for i in range(2**data_in_width):
        zeros = np.zeros(Data_width,dtype=int)
        if i % 3 == 0:
            index = random.choice(range(Data_width))
            zeros[index] = 1
            f_noise.write(''.join(str(e) for e in zeros) + '\n')
        elif i % 3 == 1:
            indexes = random.sample(range(Data_width), 2)
            zeros[indexes[0]] = 1
            zeros[indexes[1]] = 1
            f_noise.write(''.join(str(e) for e in zeros)  + '\n')
        else:
            f_noise.write(''.join(str(e) for e in zeros)  + '\n')

    f_noise.close()

def make_full_channel_files():
    make_noise_file()
    f_full_channel_in = open("golden_model_inputs_2"+str(data_mode)+".txt", "wt")
    f_full_channel_out = open("golden_model_outputs_2"+str(data_mode)+".txt", "wt")
    form = "{0:0" + str(data_in_width) + "b}"
    cntr = 1
    for i in range(2 ** data_in_width):
        inp = form.format(i)
        f_full_channel_in.write(inp + '\n')
        f_full_channel_out.write(inp +' '+str(cntr)+ '\n')
        cntr = (cntr+1)%3
    f_full_channel_in.close()
    f_full_channel_out.close()


for data_mode in range(2):
    if data_mode == 0:
        Data_width = 8
    else:
        Data_width = 16
    data_in_width = int(Data_width - np.log2(Data_width)-1)
    make_encode_files()
    make_decode_files()
    make_full_channel_files()