module main

struct Cell {
	x   int
	y   int
	cat string
mut:
	parent   &Cell
	distance int = 1000
	visited  bool
	size     int = 0
}

fn (mut c Cell) increase_size() {
	c.size += 1
}

fn (c Cell) print_cell() {
	println('x: ${c.x}, y: ${c.y}')
}

fn init_cell(x int, y int, cat string) Cell {
	return Cell{
		x: x
		y: y
		cat: cat
	}
}
