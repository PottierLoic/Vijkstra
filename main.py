from tkinter import *
import random
import numpy as np

BACKGROUND_COLOR = "#000000"
GRID_WIDTH = 20
GRID_HEIGHT = 20
CELL_SIZE = 20

grid = np.zeros((GRID_WIDTH, GRID_HEIGHT))

def graphics():
    canvas.delete("all")
    for i in range(GRID_WIDTH):
        for j in range(GRID_HEIGHT):
            if grid[i][j] == 0:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="black", outline="white")   
            elif grid[i][j] == 1:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="grey", outline="white")
            elif grid[i][j] == 2:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="red", outline="white")
            elif grid[i][j] == 3:
                canvas.create_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE+CELL_SIZE, j*CELL_SIZE+CELL_SIZE, fill="green", outline="white")

def dijkstra():
    pass

def update():
    graphics()
    window.update()
    window.after(100, update)

def leftClick(event):
    x = event.x//CELL_SIZE
    y = event.y//CELL_SIZE
    grid[x][y] = colorType

def changeColor():
    global colorType
    print(colorType)
    colorType +=1
    if colorType > 3:
        colorType = 0
    
# variables
colorType = 1


# Tkinter section.
window = Tk()
window.title("Dijkstra")

canvas = Canvas(window, bg=BACKGROUND_COLOR, height=GRID_HEIGHT*CELL_SIZE, width=GRID_WIDTH*CELL_SIZE)
canvas.pack()

window.update()

#Bindings
window.bind("<Button-1>", lambda e: leftClick(e))
window.bind("<Button-3>", lambda e: changeColor())

# Main loop.
update()

window.mainloop()