from cell import Cell

class Grid:
    def __init__(self, width, height) -> None:
        self.obstacles = [[Cell for i in range(width)] for j in range(height)]
        self.start = [0, 0]
        self.end = [height-1, width-1]

        self.path = []

    def cell(self, x, y):
        return self.obstacles[x][y]

    def change_obstacle(self, x, y):
        if self.cell(x, y) == Cell and [x, y] not in [self.start, self.end]:
            self.obstacles[x][y] = 1
        else:
            self.obstacles[x][y] = Cell

    def chage_start(self, x, y):
        self.start = [x, y]
        
    def change_end(self, x, y):
        self.end = [x, y]

    def get_adj(self, x, y):
        adj = []
        if x > 0: 
            adj.append((x-1, y))

        if x < len(self.obstacles)-1: 
            adj.append((x+1, y))

        if y > 0: 
            adj.append((x, y-1))

        if y < len(self.obstacles[0])-1: 
            adj.append((x, y+1))
        return adj

    def __str__(self) -> str:
        rString = ""
        for row in self.obstacles:
            for val in row:
                rString += str(val) + " "
            rString += "\n"
        return rString