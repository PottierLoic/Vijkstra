module main

import gg
import gx

const (
	background_color = gx.black
	grid_height = 20
	grid_width = 20
	cell_size = 20
	screen_width = grid_width * cell_size
	screen_height = grid_height * cell_size
)

struct App {
	mut:
		gg &gg.Context = unsafe { nil }
		grid Grid
}

fn (app App) display () {
	for i in 0 .. grid_height {
		for j in 0 .. grid_width {
			if app.grid.cells[i][j].cat == 'obstacle' {
				app.gg.draw_rect_filled(j * cell_size, i * cell_size, cell_size, cell_size, gx.gray)
			}
		}
	}

	for visited in app.grid.visited {
		app.gg.draw_rect_filled(visited.x * cell_size, visited.y * cell_size, cell_size, cell_size, gx.blue)
	}

	for path in app.grid.path {
		app.gg.draw_rect_filled(path.x * cell_size, path.y * cell_size, cell_size, cell_size, gx.green)
	}

	app.gg.draw_rect_filled(app.grid.start_cell[0] * cell_size, app.grid.start_cell[1] * cell_size, cell_size, cell_size, gx.green)
	app.gg.draw_rect_filled(app.grid.end_cell[0] * cell_size, app.grid.end_cell[1] * cell_size, cell_size, cell_size, gx.red)
}

fn (mut app App)solver(){
	if app.grid.found != true {
		dijkstra(app, mut app.grid)
		app.solver()
	} else {
		print('trouvé')
		path_tracer(app.grid.get_end(), mut app.grid)
		app.display()
	}
}

fn path_tracer(cell Cell, mut grid Grid) {
	grid.path << cell
	println("added to path: $cell.x $cell.y")
	println("parent: $cell.parent.x $cell.parent.y")
	if cell.parent != unsafe { nil } {
		path_tracer(cell.parent, mut grid)
	}
}

fn dijkstra (app App, mut grid Grid) {
	println('dijkstra')
	for mut neighbour in grid.get_neighbours(grid.curr.x, grid.curr.y) {
		neighbour.distance = min(neighbour.distance, grid.curr.distance + 1)
		neighbour.parent = &grid.curr
		grid.cells[neighbour.y][neighbour.x] = neighbour
	}
	grid.cells[grid.curr.y][grid.curr.x].visited = true
	grid.visited << grid.curr
	grid.curr = grid.get_nearest()
	if grid.curr == grid.get_end() {
		grid.found = true
	} else {
		app.display()
	}
}

fn frame(mut app App) {
	app.gg.begin()
	app.display()
	app.gg.end()
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		cell_x := int(x / cell_size)
		cell_y := int(y / cell_size)
		app.grid.set_obstacle(cell_x, cell_y)
	}
}

fn keydown(code gg.KeyCode, mod gg.Modifier, mut app App) {
	if code == gg.KeyCode.enter {
		app.solver()
	}
}

fn min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

fn main() {
	mut app := App {
		gg: 0
		grid: init_grid(grid_width, grid_height)
	}
	app.gg = gg.new_context(
		bg_color: background_color
		frame_fn: frame
		user_data: &app
		width: screen_width
		height: screen_height
		create_window: true
		resizable: false
		window_title: 'Dijkstra'
		click_fn: click
		keydown_fn: keydown
	)

	app.gg.run()
}