class GameOfLife:

    def __init__(self, size_of_board, starting_position, rules):
        ''' init method for class GameOfLife.
        Input size_of_board donates the size of the board, is an integer bigger than 9 and smaller than 1000.
        starting_position donates the starting position options, please refer to the added PDF file. Is an integer.
        rules donates the rules of the game. Is a string
        Output None.
        '''
        raise NotImplementedError

    def update(self):
        ''' This method updates the board game by the rules of the game.
        Input None.
        Output None.
        '''
        raise NotImplementedError

    def save_board_to_file(self, file_name):
        ''' This method saves the current state of the game to a file. You should use Matplotlib for this.
        Input img_name donates the file name. Is a string, for example file_name = '1000.png'
        Output a file with the name that donates filename.
        '''
        raise NotImplementedError

    def display_board(self):
        ''' This method displays the current state of the game to the screen. You can use Matplotlib for this.
        Input None.
        Output a figure should be opened and display the board.
        '''
        raise NotImplementedError

    def return_board(self):
        ''' This method returns a list of the board position. The board is a two-dimensional list that every
        cell donates if the cell is dead or alive. Dead will be donated with 0 while alive will be donated with 255.
        Input None.
        Output a list that holds the board with a size of size_of_board*size_of_board.
        '''
        raise NotImplementedError
