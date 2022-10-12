import numpy as np
import matplotlib.pyplot as plt


class Auv:

    def __init__(self, _sonar_range, _sonar_angle, _map_size, _initial_position, _velocity, _duration, _mines_map):
        ''' init method for class Auv.
        Input _sonar_range - An integer with values between 3-9, denote the range of the sonar
        _sonar_angle - An integer with values between 15-85 in degrees, denote half of the field of view angle
        _map_size - a tuple (Height, Width) of the map
        _initial_position - a tuple (Py, Px). The starting point of the AUV.
        _velocity - a tuple of lists. each donates a velocity ([Vy1, Vx1], [Vy2, Vx2]...)
        _duration - a lists of integers. each denote the time to run the simulation
                                         with the matching velocity [t1, t2,...]
        _mines_map - a list of lists holding the location of all the mines.
        Output None.
        '''
        self.mine_coordinates = []
        self.board = create_np_board(_map_size, _mines_map)
        plt.matshow(board)
        plt.show()
        plt.matshow(_mines_map)
        plt.show()



        raise NotImplementedError

    def create_np_board(self, _map_size, _mines_map):
        board = np.zeros((_map_size[0], _map_size[1]))
        for row in _mines_map:
            for column in row:
                if column == 1:
                    board[_mines_map.index(row)][row.index(column)] = 1
                    self.mine_coordinates.append((_mines_map.index(row), row.index(column)))
        return board


    def get_mines(self):
        ''' Returns the position of all the mines that the AUV has found.
        Input None.
        Output A list of tuples. Each tuple holds the coordinates (Yi , Xi) of found mines. The list should be sorted.
        '''
        raise NotImplementedError

    def get_sonar_fov(self):
        ''' Returns all the current  (Yi , Xi) coordinates of the map which are in range for the sonar
        Input None.
        Output A dictionary. The keys of the dictionary are tuples of the (Yi , Xi) coordinates
        and the value should be Boolean True
        '''
        raise NotImplementedError

    def display_map(self):
        ''' Display the current map.
        Input None.
        Output None
        '''
        raise NotImplementedError

    def get_heading(self):
        ''' Returns the Direction of movement of the AUV in Degrees. The heading will be between 0-360.
                    With respect to the x and y axes of the map.
        Input None.
        Output the Direction of movement of the AUV in Degrees.
        '''
        raise NotImplementedError

    def set_course(self, _velocity, _duration):
        ''' Receive new values for the velocity and duration properties. Append the new values to the current ones
        Input- Velocity as tuple of lists.
        Duration as list of integers
        Output None.
        '''
        raise NotImplementedError

    def time_step(self):
        ''' Propagate the simulation by one step (one second) if duration >0
        Input None.
        Output None.
        '''
        raise NotImplementedError

    def start(self):
        ''' Activate the simulation and run until duration has ended
        Input None.
        Output None.
        '''
        raise NotImplementedError

