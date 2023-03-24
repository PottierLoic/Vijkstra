import random

from cell import Cell


class Grid:
    def __init__(self, width, height) -> None:
        """
        Initializes a grid with a width and height.

        Args:
            width (int): The width of the grid.
            height (int): The height of the grid.
        """
        self.cells = []
        for i in range(height):
            self.cells.append([])
            for j in range(width):
                self.cells[i].append(Cell(j, i, "cell"))

        self.start = [random.randint(0, height-1), random.randint(0, width-1)]
        self.end = [random.randint(0, height-1), random.randint(0, width-1)]
        self.cells[self.start[1]][self.start[0]].distance = 0

        self.visited_cells = []
        self.path = []

    def get_start(self):
        """Returns the start cell."""
        return self.cells[self.start[1]][self.start[0]]
    
    def get_end(self):
        """Returns the end cell."""
        return self.cells[self.end[1]][self.end[0]]

    def set_obstacle(self, x, y) -> None:
        """Sets a cell type to "obstacle" if it wasn't one, otherwise set it to "cell"."""
        if self.cells[y][x] != 1:
            self.cells[y][x] = Cell(x, y, "obstacle")
        else:
            self.cells[y][x] = Cell(x, y, "cell")

    def get_neighbors(self, x, y):
        """Returns a list  all the unvisited neighbors of a cell."""
        neighbors = []
        if x > 0:
            if self.cells[y][x-1].type != "obstacle" and self.cells[y][x-1].visited == False:
                neighbors.append(self.cells[y][x-1])
        if x < len(self.cells[0])-1:
            if self.cells[y][x+1].type != "obstacle" and self.cells[y][x+1].visited == False:
                neighbors.append(self.cells[y][x+1])
        if y > 0:
            if self.cells[y-1][x].type != "obstacle" and self.cells[y-1][x].visited == False:
                neighbors.append(self.cells[y-1][x])
        if y < len(self.cells)-1:
            if self.cells[y+1][x].type != "obstacle" and self.cells[y+1][x].visited == False:
                neighbors.append(self.cells[y+1][x])
        return neighbors
       
    def get_nearest(self):
        """Returns the unvisited cell with the smallest distance attribute."""
        distance = 1000
        nearest = None
        for i in range(len(self.cells)):
            for j in range(len(self.cells[i])):
                if self.cells[i][j].distance < distance and self.cells[i][j].visited == False:
                    distance = self.cells[i][j].distance
                    nearest = self.cells[i][j]
        return nearest
        