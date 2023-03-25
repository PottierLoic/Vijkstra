module main

import rand

struct Grid {
	mut:
		cells [][]Cell
		start_cell []int
		end_cell []int
		visited []Cell
		path []Cell

		curr Cell
		end Cell
		found bool
}

fn (grid Grid) get_start() []int {
	return grid.start_cell
}

fn (grid Grid) get_end() []int {
	return grid.end_cell
}

fn (grid Grid) get_cell(x int, y int) Cell {
	return grid.cells[y][x]
}

fn (mut grid Grid) set_obstacle(x int, y int) {
	if [x, y] == grid.get_start() || [x, y] == grid.get_end() {
		return
	}
	if grid.cells[y][x].cat == 'obstacle' {
		grid.cells[y][x] = init_cell(x, y, 'cell')
	} else {
		grid.cells[y][x] = init_cell(x, y, 'obstacle')
	}
}

fn (grid Grid) get_neighbours(x int, y int) []Cell {
	mut neighbours := []Cell{}
	if x > 0 {
		if grid.cells[y][x-1].cat != 'obstacle' && grid.cells[y][x-1].visited == false {
			neighbours << grid.cells[y][x-1]
		}
	}
	if x < grid.cells[0].len - 1 {
		if grid.cells[y][x+1].cat != 'obstacle' && grid.cells[y][x+1].visited == false {
			neighbours << grid.cells[y][x+1]
		}
	}
	if y > 0 {
		if grid.cells[y-1][x].cat != 'obstacle' && grid.cells[y-1][x].visited == false {
			neighbours << grid.cells[y-1][x]
		}
	}
	if y < grid.cells.len - 1 {
		if grid.cells[y+1][x].cat != 'obstacle' && grid.cells[y+1][x].visited == false {
			neighbours << grid.cells[y+1][x]
		}
	}
	return neighbours
}

fn (grid Grid) print_grid () {
	for i := 0; i < grid.cells.len; i++ {
		for j := 0; j < grid.cells[i].len; j++ {
			if grid.cells[i][j].cat == 'cell' {
				print(' ')
			} else if grid.cells[i][j].cat == 'obstacle' {
				print('X')
			}
		}
		println("")
	}
}

fn (grid Grid) get_nearest () Cell {
	mut min := 1000
	mut nearest := grid.cells[0][0]
	for i := 0; i < grid.cells.len; i++ {
		for j := 0; j < grid.cells[i].len; j++ {
			if grid.cells[i][j].visited == false && grid.cells[i][j].distance < min {
				min = grid.cells[i][j].distance
				nearest = grid.cells[i][j]
			}
		}
	}
	return nearest
}

fn init_grid(width int, height int) Grid {
	mut cells := [][]Cell{}
	mut visited := []Cell{}
	mut path := []Cell{}
	mut start_cell := [rand.intn(width) or { 0 }, rand.intn(height) or { 0 }]
	mut end_cell := [rand.intn(width) or { 0 }, rand.intn(height) or { 0 }]
	
	for i := 0; i < height; i++ {
		mut row := []Cell{}
		for j := 0; j < width; j++ {
			row << init_cell(j, i, 'cell')
		}
		cells << row
	}
	curr := cells[start_cell[1]][start_cell[0]]
	end := cells[end_cell[1]][end_cell[0]]

	return Grid{
		cells: cells
		visited: visited
		path: path
		start_cell: start_cell
		end_cell: end_cell
		curr: curr
		end: end
	}
}



