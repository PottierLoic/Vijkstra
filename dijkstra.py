from tkinter import *

from grid import Grid

BACKGROUND_COLOR = "#000000"
GRID_WIDTH = 20
GRID_HEIGHT = 20
CELL_SIZE = 20

def graphics():
    canvas.delete("all")
    for i in range(GRID_WIDTH):
        for j in range(GRID_HEIGHT):
            if grid.cells[j][i].type == "obstacle":
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="grey", outline="grey")
    for visited_cell in grid.visited_cells:
        canvas.create_rectangle(visited_cell.x*CELL_SIZE, visited_cell.y*CELL_SIZE, visited_cell.x*CELL_SIZE+CELL_SIZE, visited_cell.y*CELL_SIZE+CELL_SIZE, fill="orange", outline="orange")
    for cell in grid.path:
        canvas.create_rectangle(cell[0]*CELL_SIZE, cell[1]*CELL_SIZE, cell[0]*CELL_SIZE+CELL_SIZE, cell[1]*CELL_SIZE+CELL_SIZE, fill="green", outline="green")
    canvas.create_rectangle(grid.start[0]*CELL_SIZE, grid.start[1]*CELL_SIZE, grid.start[0]*CELL_SIZE+CELL_SIZE, grid.start[1]*CELL_SIZE+CELL_SIZE, fill="blue")
    canvas.create_rectangle(grid.end[0]*CELL_SIZE, grid.end[1]*CELL_SIZE, grid.end[0]*CELL_SIZE+CELL_SIZE, grid.end[1]*CELL_SIZE+CELL_SIZE, fill="red", outline="red")
    window.update()

def path_tracer(cell):
    global grid
    grid.path.append([cell.x, cell.y])
    if cell.parent != None:
        path_tracer(cell.parent)
        graphics()

def dijkstra(grid):
    global curr, end, found
    for neighbor in grid.get_neighbors(curr.x, curr.y):
        neighbor.distance = min(neighbor.distance, curr.distance+1)
        neighbor.parent = curr
    curr.visited = True
    curr = grid.get_nearest()
    grid.visited_cells.append(curr)
    if grid.get_nearest() == grid.get_end():
        found = True
    else:
        graphics()
            
def left_click(event):
    x = event.x//CELL_SIZE
    y = event.y//CELL_SIZE
    grid.set_obstacle(x, y)
    graphics()

def right_click():
    global grid, curr, end, found
    grid = init_grid()
    curr = grid.get_start()
    end = grid.get_end()
    found = False
    graphics()

def init_grid() -> Grid:
    global curr, end, found
    g = Grid(GRID_WIDTH, GRID_HEIGHT)
    curr = g.get_start()
    end = g.get_end()
    found = False
    return g

def solver():
    global found
    if not found:
        dijkstra(grid)
        window.after(1, solver)
    else:
        path_tracer(grid.get_end())
    

# Tkinter section.
window = Tk()
window.title("Dijkstra")

canvas = Canvas(window, bg=BACKGROUND_COLOR, height=GRID_HEIGHT*CELL_SIZE, width=GRID_WIDTH*CELL_SIZE)
canvas.pack()

window.update()

#Bindings
window.bind("<Button-1>", lambda e: left_click(e))
window.bind("<Button-3>", lambda e: right_click())
window.bind("<Return>", lambda e: solver())

# variables
grid = init_grid()
curr = grid.get_start()
end = grid.get_end()
found = False

graphics()

window.mainloop()