import numpy as np
import matplotlib.pyplot as plt


class HydroCamel:
    def __init__(self, _sonar_range, _sonar_angle, _map_size, _initial_position, _velocity, _duration, _mines_map):
        ''' init method for class Auv.
        Input _sonar_range - An integer with values between 3-9, denote the range of the sonar
        _sonar_angle - An integer with values between 15-90 in degrees, denote half of the field of view angle
        _map_size - a tuple (Height, Width) of the map
        _initial_position - a tuple (Py, Px). The starting point of the AUV.
        _velocity - a tuple of lists. each donates a velocity ([Vy1, Vx1], [Vy2, Vx2]...)
        _duration - a lists of integers. each denote the time to run the simulation
                                         with the matching velocity [t1, t2,...]
        _mines_map - a list of lists holding the location of all the mines.
        Output None.
        '''
        self.turn_angle = 0
        self._initial_position = _initial_position
        if _sonar_angle == 45:
            _sonar_angle += 10**(-3)
            _sonar_range += 10**(-3)
        self._sonar_angle = np.radians(_sonar_angle)
        self._sonar_range = _sonar_range
        self.find_first_abc()
        self.mine_coordinates = []
        self.board = np.matrix(_mines_map)
        self.found_mines = []
        self._duration = _duration
        if isinstance(_velocity[0], int):
            self._velocity = [list(_velocity)]
        else:
            self._velocity = list(_velocity)
        self.step = 0
        self.next_step = 'turn'
        self.get_sonar_fov()

    def find_first_abc(self):
         self.a = self._initial_position
         distance_x = self._sonar_range * np.cos(self._sonar_angle)
         distance_y = self._sonar_range * np.sin(self._sonar_angle)
         self.b = (self.a[0] + distance_y, self.a[1] + distance_x)
         self.c = (self.a[0] - distance_y, self.a[1] + distance_x)

    def get_mines(self):
        ''' Returns the position of all the mines that the AUV has found.
        Input None.
        Output A list of tuples. Each tuple holds the coordinates (Yi , Xi) of found mines. The list should be sorted.
        '''
        for cordinate in self.get_sonar_fov():
            if self.board[cordinate] == 1:
                if cordinate not in self.found_mines:
                    self.found_mines.append(cordinate)
        self.found_mines = self.quicksort_found_mines(self.found_mines)
        return self.found_mines

    def quicksort_found_mines(self, found_mines):
        found_mines = self.sort(found_mines, 1)
        if found_mines != []:
            temp = [found_mines[0]]
            sorted_found_mines = []
            for i in range(1, len(found_mines)):
                if found_mines[i][1] == found_mines[i-1][1]:
                    temp.append(found_mines[i])
                else:
                    sorted_found_mines = sorted_found_mines + self.sort(temp, 0)
                    temp = [found_mines[i]]
            sorted_found_mines = sorted_found_mines + self.sort(temp, 0)
            return sorted_found_mines
        else:
            return found_mines

    def sort(self, array, axis):
        less = []
        equal = []
        greater = []

        if len(array) > 1:
            pivot = array[len(array)//2]
            for x in array:
                if x[axis] < pivot[axis]:
                    less.append(x)
                if x[axis] == pivot[axis]:
                    equal.append(x)
                if x[axis] > pivot[axis]:
                    greater.append(x)
            return self.sort(less, axis) + equal + self.sort(greater, axis)
        else:
            return array

    def get_sonar_fov(self):
        ''' Returns all the current  (Yi , Xi) coordinates of the map which are in range for the sonar
        Input None.
        Output A dictionary. The keys of the dictionary are tuples of the (Yi , Xi) coordinates
        and the value should be Boolean True
        '''
        fov_dict = {}
        y_max = int(max(self.a[0], self.b[0], self.c[0]))+2
        y_min = int(min(self.a[0], self.b[0], self.c[0]))-2
        x_max = int(max(self.a[1], self.b[1], self.c[1]))+2
        x_min = int(min(self.a[1], self.b[1], self.c[1]))-2
        if self.c[0] == self.a[0]:
            temp = self.b
            self.b = self.c
            self.c = temp
        a = self.a
        b = self.b
        c = self.c
        for y in range(y_min, y_max + 1):
            for x in range(x_min, x_max+1):
                w1 = (a[1]*(c[0] - a[0]) + (y - a[0])*(c[1] - a[1]) - x * (c[0] - a[0])) / ((b[0] - a[0])*(c[1] - a[1]) - (b[1] - a[1])*(c[0] - a[0]))
                w2 = (y - a[0] - w1 * (b[0] - a[0])) / (c[0] - a[0])
                if w1 >= 0 and w2 >= 0 and w1 + w2 <= 1:
                    fov_dict[(y, x)] = True
        return fov_dict

    def display_map(self):
        ''' Display the current map.
        Input None.
        Output None
        '''
        self.board[self._initial_position] += 2
        fov_dict = self.get_sonar_fov()
        for cordinate in fov_dict:
            self.board[cordinate] += 3
        plt.matshow(self.board)
        plt.show()
        self.board[self._initial_position] -= 2
        for cordinate in fov_dict:
            self.board[cordinate] -= 3

    def get_heading(self):
        ''' Returns the Direction of movement of the AUV in Degrees. The heading will be between 0-360.
                    With respect to the x and y axes of the map.
        Input None.
        Output the Direction of movement of the AUV in Degrees.
        '''
        if np.degrees(self.turn_angle) < 0:
            return np.degrees(self.turn_angle)+360
        else:
            return np.degrees(self.turn_angle)

    def set_course(self, new_velocity, new_duration):
        ''' Receive new values for the velocity and duration properties. Append the new values to the current ones
        Input- Velocity as tuple of lists.
        Duration as list of integers
        Output None.
        '''
        self._velocity = self._velocity + new_velocity
        self._duration = self._duration + new_duration

    def time_step(self):
        ''' Propagate the simulation by one step (one second) if duration >0
        Input None.
        Output None.
        '''
        i = self.step
        if self.next_step == 'turn':
            self.turn_sonar(self._velocity[i])
        if self._duration[i] > 0:
            self._duration[i] = self._duration[i] - 1
            self._initial_position = (self._initial_position[0]+self._velocity[i][0], self._initial_position[1]+self._velocity[i][1])
            self.a = (self.a[0]+self._velocity[i][0], self.a[1]+self._velocity[i][1])
            self.b = (self.b[0]+self._velocity[i][0], self.b[1]+self._velocity[i][1])
            self.c = (self.c[0]+self._velocity[i][0], self.c[1]+self._velocity[i][1])
            if self._duration[i] == 0:
                self.step += 1
                self.next_step = 'turn'
            else:
                self.next_step = ' dont turn'
        self.get_mines()

    def turn_sonar(self, _velocity):
        self.turn_angle = np.arctan2(_velocity[0], _velocity[1]) - self.turn_angle
        cos = np.cos(self.turn_angle)
        sin = np.sin(-self.turn_angle)
        turn_mat = ([[cos, -sin],[sin,cos]])
        self.b = (self.b[0]-self.a[0], self.b[1]-self.a[1])
        self.c = (self.c[0]-self.a[0], self.c[1]-self.a[1])
        self.b = turn_mat @ np.array([self.b[0],self.b[1]])
        self.c = turn_mat @ np.array([self.c[0],self.c[1]])
        self.b = (self.b[0]+self.a[0]), (self.b[1]+self.a[1])
        self.c = (self.c[0]+self.a[0]), (self.c[1]+self.a[1])
        self.turn_angle = np.arctan2(_velocity[0], _velocity[1])

    def start(self):
        ''' Activate the simulation and run until duration has ended
        Input None.
        Output None.
        '''
        while self._duration[self.step] > 0:
            self.time_step()
            if self.step == len (self._duration):
                break


if __name__ == "__main__":
    # example 2
    sonar_range = 5
    sonar_angle = 30
    map_size = (25, 20)
    initial_position = (10, 10)
    velocity = list()
    velocity.append([2, 2])
    velocity.append([-2, -2])
    velocity.append([0, 2])
    velocity.append([2, 0])
    duration = [2, 2, 2, 2]
    mines = np.random.choice([1, 0], map_size, p=[0.05, 0.95]).tolist()
    mines[10][14] = 1

    game2 = HydroCamel(sonar_range, sonar_angle, map_size, initial_position, velocity, duration, mines)
    #game2.start()
    game2.display_map()
    for i in range(8):
        game2.time_step()
        print(game2.get_heading())
        print(game2.get_sonar_fov())
        print(game2.get_mines())

        game2.display_map()
    print(game2.get_mines())
