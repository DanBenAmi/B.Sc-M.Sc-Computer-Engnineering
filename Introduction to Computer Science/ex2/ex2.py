import game_of_life_interface
import numpy as np
import matplotlib.pyplot as plt


class GameOfLife(game_of_life_interface.GameOfLife):  # This is the way you construct a class that heritage properties

    def __init__(self, size_of_board, starting_position=1, rules='default'):
        ''' init method for class GameOfLife.
        Input size_of_board donates the size of the board, is an integer bigger than 9 and smaller than 1000.
        starting_position donates the starting position options, please refer to the added PDF file. Is an integer.
        rules donates the rules of the game. Is a string
        Output None.
        '''

        DEAD = 0
        ALIVE = 255
        self.size_of_board = size_of_board
        D_A = (DEAD, ALIVE)  # list of the values represent dead or alive
        # this part is setting the board according to the starting position
        if starting_position < 1 or starting_position > 6:
            starting_position = 1
        if starting_position == 1:
            board = np.random.choice(D_A, size_of_board * size_of_board).reshape(size_of_board, size_of_board)
        elif starting_position == 2:
            board = np.random.choice(D_A, size_of_board * size_of_board, p=[0.2, 0.8]).reshape(size_of_board,
                                                                                               size_of_board)
        elif starting_position == 3:
            board = np.random.choice(D_A, size_of_board * size_of_board, p=[0.8, 0.2]).reshape(size_of_board,
                                                                                               size_of_board)
        elif starting_position == 4:
            board = np.zeros(shape=(size_of_board, size_of_board))
            gun = np.zeros(11 * 38).reshape(11, 38)
            gun[5][1] = gun[5][2] = gun[6][1] = gun[6][2] = gun[3][13] = gun[3][14] = 255
            gun[4][12] = gun[4][16] = gun[5][11] = gun[5][17] = gun[6][11] = gun[6][15] = 255
            gun[6][17] = gun[6][18] = gun[7][11] = gun[7][17] = gun[8][12] = gun[8][16] = 255
            gun[9][13] = gun[9][14] = gun[1][25] = gun[2][23] = gun[2][25] = gun[3][21] = gun[3][22] = 255
            gun[4][21] = gun[4][22] = gun[5][21] = gun[5][22] = gun[6][23] = gun[6][25] = 255
            gun[7][25] = gun[3][35] = gun[3][36] = gun[4][35] = gun[4][36] = 255
            board[9:9 + 11, 9:9 + 38] = gun
        elif starting_position == 5:
            board = np.zeros(shape=(size_of_board, size_of_board))
            pulsar = np.zeros(17 * 17).reshape(17, 17)
            pulsar[2, 4:7] = pulsar[4:7, 7] = 255
            pulsar = pulsar + pulsar.T
            pulsar = pulsar + + pulsar[:, ::-1]
            pulsar = pulsar + pulsar[::-1, :]
            board[int(size_of_board / 2 - 8):int(size_of_board / 2 - 8) + 17,
            int(size_of_board / 2 - 8):int(size_of_board / 2 - 8) + 17] = pulsar
        elif starting_position == 6:
            board = np.zeros(shape=(size_of_board, size_of_board))
            board[5][5] = board[5][8] = board[6][6] = board[6][7] = 255

        # this part is setting two lists "born" and "survive"/ each list contain the numbers of neighbors
        # that a cell need in order to born/survive.
        self.board = board
        born = []
        survive = []
        slash_index = rules.index('/')
        for i in range(1, slash_index):
            born.append(int(rules[i]))
        for i in range(slash_index + 2, len(rules)):
            survive.append(int(rules[i]))
        self.born = born
        self.survive = survive


    def update(self):
        ''' This method updates the board game by the rules of the game.
        Input None.
        Output None.
        '''
        size_of_board = self.size_of_board
        born = self.born
        survive = self.survive
        mat_zeros = np.zeros(shape=(size_of_board + 2, size_of_board + 2))
        mat_zeros[1:1 + size_of_board, 1:1 + size_of_board] = self.board
        board_plus2 = mat_zeros
        mat_zeros = np.zeros(shape=(size_of_board + 2, size_of_board + 2))
        for i in range(1, size_of_board + 1):
            for j in range(1, size_of_board + 1):
                sum_neighbors = 0
                for x in (-1, 0, 1):
                    for y in (-1, 0, 1):
                        if x != 0 or y != 0:
                            sum_neighbors = sum_neighbors + board_plus2[i + x, j + y] / 255
                if board_plus2[i, j] == 255:
                    if sum_neighbors in survive:
                        mat_zeros[i, j] = 255
                else:
                    if sum_neighbors in born:
                        mat_zeros[i,j] = 255
        self.board = mat_zeros[1:size_of_board + 1, 1:size_of_board + 1]

    def save_board_to_file(self, file_name):
        ''' This method saves the current state of the game to a file. You should use Matplotlib for this.
        Input img_name donates the file name. Is a string, for example file_name = '1000.png'
        Output a file with the name that donates filename.
        '''
        plt.imsave(file_name, self.board)

    def display_board(self):
        ''' This method displays the current state of the game to the screen. You can use Matplotlib for this.
        Input None.
        Output a figure should be opened and display the board.
        '''

        plt.matshow(self.board)
        return plt.show()

    def return_board(self):
        ''' This method returns a list of the board position. The board is a two-dimensional list that every
        cell donates if the cell is dead or alive. Dead will be donated with 0 while alive will be donated with 255.
        Input None.
        Output a list that holds the board with a size of size_of_board*size_of_board.
        '''
        return self.board


if __name__ == '__main__':  # You should keep this line for our auto-grading code.
    # print('write your code here')  # don't forget to indent your code here!
    import time
    start = time.time()
    gol = GameOfLife(100, 4, 'B3/S23')
    for i in range(568):
        gol.update()
    end = time.time()
    gol.display_board()
    gol.save_board_to_file('test.png')
    print(end-start)
