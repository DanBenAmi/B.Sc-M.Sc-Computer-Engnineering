import Huffman_code_interface
from functools import total_ordering
import os
import math

@total_ordering
class Node:

    def __init__(self, chr, freq):

        self.left = None
        self.right = None
        self.chr = chr
        self.freq = freq

# unite two nodes into one father node
    def unite_txt_nodes(self, other):

        father_node = Node(self.chr + other.chr, self.freq + other.freq)
        if self.freq >= other.freq:
            father_node.right = self
            father_node.left = other
        else:
            father_node.right = other
            father_node.left = self
        return father_node

    def unite_bin_nodes(self, other):

        father_node = Node(self.chr + ' ' + other.chr, self.freq + other.freq)
        if self.freq >= other.freq:
            father_node.right = self
            father_node.left = other
        else:
            father_node.right = other
            father_node.left = self
        return father_node

#check which node has the lower/greater frequency
    def __le__(self, other):
        return  self.freq <= other.freq
    def __ge__(self, other):
        return self.freq >= other.freq



class HuffmanCoding(Huffman_code_interface.HuffmanCoding):  # This is the way you construct a class that inherits properties

    def __init__(self, input_file_path):
        ''' init method for class HuffmanCoding.
        input_file_path is a string containing the path to a file which needs to be compressed
        '''
        typefile = self.check_file_type(input_file_path)

        self.type = typefile

        text = self.save_file_text(input_file_path, typefile)

        self.freq_dict = self.make_frequency_dict(text)

        self.root = self.make_a_tree()

        self.coding_dictionary = self.make_coding_dictionary()

        encoded_text = self.text2bintext(text)

        self.encoded_text_withzeros = self.add_zeros_and_startbyte(encoded_text)

        self.compressed_file_path = self.save_comressed_file(input_file_path)



#takes the self.encoded_text_withzeros and the path of the original file as input, and saves a bin file in the directory
    def save_comressed_file(self,input_file_path):
        if (len(self.encoded_text_withzeros) % 8 != 0):
            print("Encoded text not padded properly")
            exit(0)

        b = bytearray()
        for i in range(0, len(self.encoded_text_withzeros), 8):
            byte = self.encoded_text_withzeros[i:i + 8]
            b.append(int(byte, 2))

        compressed_file = open(input_file_path[:-4] + ' compressed file.bin', 'wb')
        compressed_file.write(bytes(b))
        compressed_file.close()
        return input_file_path[:-4] + ' compressed file.bin'


#takes the input_file_path of the original file and save the type of file in self.type
    def check_file_type(self, input_file_path):
        if os.path.splitext(input_file_path)[-1].lower() == ".txt":
            type = '.txt'
        else :
            type = '.bin'
        return type

# takes binary text, adding a zeros in the end and a byte with the num of zeros added in begin
    def add_zeros_and_startbyte(self, encoded_text):
        extra_zeros = 8 - len(encoded_text) % 8
        for i in range(extra_zeros):
            encoded_text += "0"
        zeros_info = "{0:08b}".format(extra_zeros)
        encoded_text = zeros_info + encoded_text
        return encoded_text


#takes the text and the self.chr2bin_dict and convert each char to binary text
    def text2bintext(self, text):
        encoded_text = ''
        for chr in text:
            encoded_text += self.coding_dictionary[str(chr)]
        return encoded_text

#takes the root and the freq_dict, makes a dictionary which contain the bin code to each char
    def make_coding_dictionary(self):
        chr_dict = self.freq_dict.copy()
        for chr, val in chr_dict.items():
            val = ''
            chr = '_' + chr + '_'
            tmp_node = self.root
            while chr != tmp_node.chr:
                if chr in tmp_node.right.chr:
                    val = val + '1'
                    tmp_node = tmp_node.right
                elif chr in tmp_node.left.chr:
                    val = val + '0'
                    tmp_node = tmp_node.left
            chr = chr[1:-1]
            chr_dict[chr] = val
        return chr_dict

#takes a list and do quicksort
    def quicksort(self, array):
        """
        Sorts an array of integers using the quick-sort algorithm.

        :param array: the array to be sorted
        :type array: list<int>
        :return: the sorted array
        :rtype: list<int>
        """
        indexes_stack = list()
        idx = (0, len(array) - 1)
        indexes_stack.append(idx)
        for idx in indexes_stack:
            elem_idx = idx[0]
            pivot_idx = idx[1]
            while pivot_idx > elem_idx:
                pivot = array[pivot_idx]
                elem = array[elem_idx]
                if elem > pivot:
                    array[pivot_idx] = elem
                    array[elem_idx] = array[pivot_idx - 1]
                    array[pivot_idx - 1] = pivot
                    pivot_idx -= 1
                else:
                    elem_idx += 1

            boundar_low = idx[0]
            boundar_high = idx[1]
            if pivot_idx > 1 and boundar_low < pivot_idx - 1:
                indexes_stack.append((boundar_low, pivot_idx - 1))
            if pivot_idx < len(array) - 1 and pivot_idx + 1 < boundar_high:
                indexes_stack.append((pivot_idx + 1, boundar_high))

        return array

    # takes the frequency dict and makes Huaffman tree, return the root of the tree
    def make_a_tree(self):
        Nodes_list = []
        for key in self.freq_dict:
            Nodes_list.append(Node('_' + str(key) + '_', self.freq_dict[key]))
        while len(Nodes_list) > 1:
            Nodes_list = self.quicksort(Nodes_list)
            if self.type == '.txt':
                tmp_node = (Nodes_list[0]).unite_txt_nodes(Nodes_list[1])
            else:
                tmp_node = (Nodes_list[0]).unite_bin_nodes(Nodes_list[1])
            Nodes_list.remove(Nodes_list[1])
            Nodes_list.remove(Nodes_list[0])
            Nodes_list.append(tmp_node)
        root = Nodes_list[0]
        return root

    #takes the text and return a dictionary with each cahr as keys and frequencys as values
    def make_frequency_dict(self, text):
        chr_freq = {}
        for chr in text:
            chr = str(chr)
            if chr in chr_freq:
                chr_freq[chr] += 1
            else:
                chr_freq[chr] = 1
        return chr_freq

# takes the self.compressed_file_path and return byte type object or string
    def save_file_text(self, input_file_path, typefile):
        if typefile == '.txt' :
            file = open(input_file_path,'rt')
            text = file.read()
        else :
            file = open(input_file_path,'rb')
            text = file.read()
        file.close()
        return text

    def decompress_file(self, input_file_path):
        ''' This method decompresses a previously compressed file.
        Input: input_file_path - path to compressed file.
        Output path to decompressed file (string).
        '''
        typefile = self.check_file_type(input_file_path)
        bytes = self.save_file_text(input_file_path, typefile)
        bintext = self.bytes_to_binstr(bytes)
        if self.type == '.txt':
            str_text = self.binstr2textstr(bintext)
            decompressed_file = open(input_file_path[:-4] + ' decompressed file' + self.type, 'wt')
            decompressed_file.write(str_text)

        else:
            bytes = self.bintext2bytes(bintext)
            decompressed_file = open(input_file_path[:-4] + ' decompressed file' + self.type, 'wb')
            decompressed_file.write(bytes)
        decompressed_file.close()
        return input_file_path[:-4] + ' decompressed file' + self.type



    def bintext2bytes(self,strbin):
        zeros_end = int(strbin[0:8], 2)
        strbin = strbin[8:-zeros_end]
        tmp = ''
        final_bytes = bytearray()
        for chr in strbin:
            tmp += chr
            for key, val in self.coding_dictionary.items():
                if val == tmp:
                    final_bytes.append(int(key))
                    tmp = ''
        return final_bytes

#takes a string of ones and zeros and convert it to string of text
    def binstr2textstr(self, strbin):
        zeros_end = int(strbin[0:8],2)
        strbin = strbin[8:-zeros_end]
        tmp = ''
        text_str = ''
        for chr in strbin:
            tmp += chr
            for key, val in self.coding_dictionary.items():
                if val == tmp:
                    text_str += key
                    tmp = ''
        return text_str


#takes a byte object  and convert it to string of 0's and 1's
    def bytes_to_binstr(self, text):
        encoded_text = ''
        for byte in text:
            tmp = bin(byte)[2:]
            while len(tmp) < 8:
                tmp = '0' + tmp
            encoded_text += tmp
        return encoded_text

    def calculate_entropy(self):
        ''' This method calculates the entropy associated with the distribution
         of symbols in a previously compressed file.
        Input: None.
        Output: entropy (float).
        '''
        sum = 0
        for key in self.freq_dict:
            sum = sum + self.freq_dict[key]
        for key in self.freq_dict:
            self.freq_dict[key] = self.freq_dict[key] / sum
        entropy = 0
        for key in self.freq_dict:
            entropy = entropy - self.freq_dict[key] * math.log(self.freq_dict[key],2)
        return entropy



if __name__ == '__main__':# # You should keep this line for our auto-grading code.
    import time

    start = time.time()
    hf = HuffmanCoding('large_binary.bin')
    hf.decompress_file(hf.compressed_file_path)
    end = time.time()
    print(end - start)

    '''mytest = HuffmanCoding('C:/Users/danbe/Desktop/pic.bin')
    print(mytest.coding_dictionary)
    print(mytest.type)
    print(mytest.compressed_file_path)
    decomp_path = mytest.decompress_file(mytest.compressed_file_path)
    with open('C:/Users/danbe/Desktop/pic.bin', 'rb') as f1, open('C:/Users/danbe/Desktop/pic compressed file decompressed file.bin', 'rb') as f2:
        data1 = f1.read()
        data2 = f2.read()
        f1.close()
        f2.close()
    print("Test number 1", "Source size equal to decompressed size:", data1 == data2)

    print(decomp_path)'''
