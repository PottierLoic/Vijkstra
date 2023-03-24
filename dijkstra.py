from tkinter import *
import random
import numpy as np

from grid import Grid

BACKGROUND_COLOR = "#000000"
GRID_WIDTH = 20
GRID_HEIGHT = 20
CELL_SIZE = 20

def graphics():
    canvas.delete("all")
    for i in range(GRID_WIDTH):
        for j in range(GRID_HEIGHT):
            if grid.cell(i, j) == 0:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="black")   
            elif grid.cell(i, j) == 1:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="grey")
    canvas.create_rectangle(grid.start[0]*CELL_SIZE, grid.start[1]*CELL_SIZE, grid.start[0]*CELL_SIZE+CELL_SIZE, grid.start[1]*CELL_SIZE+CELL_SIZE, fill="green")
    canvas.create_rectangle(grid.end[0]*CELL_SIZE, grid.end[1]*CELL_SIZE, grid.end[0]*CELL_SIZE+CELL_SIZE, grid.end[1]*CELL_SIZE+CELL_SIZE, fill="red", outline="white")
    window.update()

def dijkstra(grid):
    distances = np.full((GRID_WIDTH, GRID_HEIGHT), 10000)
    distances[grid.start[1]][grid.start[0]] = 0

    curr = grid.start

    visited = np.full((GRID_WIDTH, GRID_HEIGHT), None)

    visited[curr[1], curr[0]] = True
    if grid.cell(curr[1], curr[0]) != 1:
        grid.cell(curr[1], curr[0]).distance = 0

    while True:
        neighbours = grid.get_adj(curr[1], curr[0])

        for neighbour in neighbours:
            if grid.cell(neighbour[1], neighbour[0]) != 1:
                if distances[neighbour[1]][neighbour[0]] > distances[curr[1]][curr[0]] + 1:
                    distances[neighbour[1]][neighbour[0]] = distances[curr[1]][curr[0]] + 1
                    grid.cell(neighbour[1], neighbour[0]).parent = curr
                    grid.cell(neighbour[1], neighbour[0]).distance = distances[neighbour[1]][neighbour[0]]
                    visited[neighbour[1]][neighbour[0]] = False
        visited[curr[1], [curr[0]]] = True
            
        curr = min(neighbours, key=lambda x: distances[x[1]][x[0]])
            
        


def left_click(event):
    x = event.x//CELL_SIZE
    y = event.y//CELL_SIZE
    grid.change_obstacle(x, y)
    graphics()

def right_click():
    global grid
    grid = init_grid()
    graphics()

def init_grid() -> Grid:
    print("init")
    g = Grid(GRID_WIDTH, GRID_HEIGHT)
    g.chage_start(random.randint(0, GRID_WIDTH-1), random.randint(0, GRID_HEIGHT-1))
    g.change_end(random.randint(0, GRID_WIDTH-1), random.randint(0, GRID_HEIGHT-1))
    return g

# Tkinter section.
window = Tk()
window.title("Dijkstra")

canvas = Canvas(window, bg=BACKGROUND_COLOR, height=GRID_HEIGHT*CELL_SIZE, width=GRID_WIDTH*CELL_SIZE)
canvas.pack()

window.update()

#Bindings
window.bind("<Button-1>", lambda e: left_click(e))
window.bind("<Button-3>", lambda e: right_click())
window.bind("<Return>", lambda e: dijkstra(grid))

# variables
grid = init_grid()
graphics()

window.mainloop()