import numpy as np
import random

Data_width = 32

H3_decode = np.array([[1]*32,
               [1]*15+[0]*12+[1,0,0,0,0],
               [1]*8+[0]*7+[1]*7+[0]*6+[1,0,0,0],
               [1]*4+[0]*4+[1]*4+[0]*3+[1]*4+[0]*3+[1]*3+[0]*4+[1,0,0],
               [1,1,0,0]*3+[1,1,0]*2+[0]+[1,1,0]*2+[1,0,0,0,0,1,0],
               [1,0]*7+[1]+[1,0]*3+[1,1,0,1,1]+[0]*5+[1]
               ])

H3_encode = H3_decode[:,0:26]

data_in_width = int(Data_width - np.log2(Data_width)-1)

def flip_bit(vec, index):
    if vec[index] == 0:
        vec[index] = 1
    else:
        vec[index] = 0

def calculate_parity(inp):
    length = Data_width-data_in_width
    parity = np.array([0]*length)
    for j in range(length-1,-1,-1):
        parity[j] = H3_encode[j]@inp % 2
    for j in range(length-1,0,-1):
        parity[0] += parity[j]
    parity[0] = parity[0] % 2
    return parity

def make_encode_files():
    #encoding
    f_encoder_in = open("golden_model_inputs_02.txt","wt")
    f_encoder_out = open("golden_model_outputs_02.txt","wt")
    form = "{0:0" + str(data_in_width) + "b}"
    for i in range(2**data_in_width//2**8):
        rand_inputs = np.array([i*2**8, random.choice(range(i*2**8+1,(i+1)*2**8))])
        rand_inputs = np.array([form.format(j) for j in rand_inputs])
        for inp in rand_inputs:
            f_encoder_in.write(inp+'\n')
            inp = np.array([int(x) for x in inp])
            out  = np.concatenate((inp,calculate_parity(inp)))
            out = ''.join(str(e) for e in out)
            f_encoder_out.write(out+'\n')

    f_encoder_in.close()
    f_encoder_out.close()

def make_decode_files():
    #decode files
    f_decoder_in = open("golden_model_inputs_12.txt","wt")
    f_decoder_out = open("golden_model_outputs_12.txt","wt")
    f_encoder_in = open("golden_model_inputs_02.txt", "rt")
    f_encoder_out = open("golden_model_outputs_02.txt", "rt")
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
    f_noise = open("noise_2.txt","wt")
    cntr1 = 0
    cntr2a = 0
    cntr2b = 1
    for i in range(2**data_in_width*2//2**8):
        zeros = np.zeros(Data_width,dtype=int)
        if i % 3 == 0:
            zeros[cntr1] = 1
            f_noise.write(''.join(str(e) for e in zeros) + '\n')
            cntr1 = (cntr1 + 1) % 32
        elif i % 3 == 1:
            zeros[cntr2a] = 1
            zeros[cntr2b] = 1
            f_noise.write(''.join(str(e) for e in zeros)  + '\n')
            cntr2b = (cntr2b + 1) % 32
            if cntr2b == 0:
                cntr2a = (cntr2a + 1) % 31
                cntr2b = cntr2a + 1
        else:
            f_noise.write(''.join(str(e) for e in zeros)  + '\n')

    f_noise.close()

def make_full_channel_files():
    make_noise_file()
    f_full_channel_in = open("golden_model_inputs_22.txt", "wt")
    f_full_channel_out = open("golden_model_outputs_22.txt", "wt")
    form = "{0:0" + str(data_in_width) + "b}"
    cntr = 1
    for i in range(2 ** data_in_width // 2 ** 8):
        rand_inputs = np.array([(i+1) * 2 ** 8-1, random.choice(range(i * 2 ** 8 + 1, (i + 1) * 2 ** 8))])
        rand_inputs = np.array([form.format(j) for j in rand_inputs])
        for inp in rand_inputs:
            f_full_channel_in.write(inp + '\n')
            f_full_channel_out.write(inp +' '+str(cntr)+ '\n')
            cntr = (cntr+1)%3
    f_full_channel_in.close()
    f_full_channel_out.close()

make_encode_files()
make_decode_files()
make_full_channel_files()
make_noise_file()
