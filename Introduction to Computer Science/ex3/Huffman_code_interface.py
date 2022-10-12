class HuffmanCoding:

    def __init__(self, input_file_path):
        ''' init method for class HuffmanCoding.
        input_file_path is a string containing the path to a file which needs to be compressed
        '''
        self.compressed_file_path = None
        self.coding_dictionary = None

        raise NotImplementedError

    def decompress_file(self, input_file_path):
        ''' This method decompresses a previously compressed file.
        Input: input_file_path - path to compressed file.
        Output path to decompressed file (string).
        '''
        raise NotImplementedError

    def calculate_entropy(self):
        ''' This method calculates the entropy associated with the distribution
         of symbols in a previously compressed file.
        Input: None.
        Output: entropy (float).
        '''
        raise NotImplementedError

