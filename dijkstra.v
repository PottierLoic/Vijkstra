module main

import gg
import gx
import time

const (
	background_color  = gx.rgb(243, 243, 243)
	background_color2 = gx.rgb(213, 213, 213)
	start_color       = gx.green
	end_color         = gx.red
	visited_color     = gx.rgb(102, 178, 255)
	path_color        = gx.yellow
	obstacle_color    = gx.rgb(0, 25, 51)

	screen_width      = 1080
	screen_height     = 720

	grid_height       = 10
	grid_width        = 10
	
	cell_size         = int(720/grid_height)

	menu_size 		  = screen_width - (grid_width * cell_size)

	circle_size       = int(cell_size / 3)
	text_config       = gx.TextCfg{
		color: gx.white
		size: 20
		align: .center
		vertical_align: .middle
	}
)

struct App {
mut:
	gg         &gg.Context = unsafe { nil }
	grid       Grid
	solving    bool
	path_found bool
	path_drawn bool
	draw_timer time.StopWatch
	anim_timer time.StopWatch = time.new_stopwatch()
}

fn (mut app App) display() {
	mut odd := 0

	// Draw background and obstacles
	for i in 0 .. grid_height {
		for j in 0 .. grid_width {
			if odd == 0 {
				app.gg.draw_rect_filled(j * cell_size, i * cell_size, cell_size, cell_size,	background_color)
				odd = 1
			} else {
				app.gg.draw_rect_filled(j * cell_size, i * cell_size, cell_size, cell_size,	background_color2)
				odd = 0
			}
			if app.grid.cells[i][j].cat == 'obstacle' {
				app.gg.draw_rect_filled(j * cell_size, i * cell_size, cell_size, cell_size,	obstacle_color)
			}
		}
		if grid_width % 2 == 0 {
			if odd == 0 {
				odd = 1
			} else {
				odd = 0
			}
		}
	}

	// Draw visited cells
	for visited in app.grid.visited {
		if visited.x == app.grid.start_cell[0] && visited.y == app.grid.start_cell[1] {
			continue
		}
		app.gg.draw_circle_filled(visited.x * cell_size + cell_size / 2, visited.y * cell_size + cell_size / 2, visited.size, visited_color)
	}

	// Draw path
	for path in app.grid.path_to_draw {
		app.gg.draw_circle_filled(path.x * cell_size + cell_size / 2, path.y * cell_size + cell_size / 2, path.size, path_color)
	}

	// Draw start and end cells
	app.gg.draw_polygon_filled(app.grid.start_cell[0] * cell_size + cell_size / 2, app.grid.start_cell[1] * cell_size + cell_size / 2, circle_size, 3, 0, start_color)
	app.gg.draw_circle_filled(app.grid.end_cell[0] * cell_size + cell_size / 2, app.grid.end_cell[1] * cell_size + cell_size / 2, circle_size, end_color)

	if app.anim_timer.elapsed().milliseconds() > 10 {
		for mut cell in app.grid.visited {
			if cell.size != circle_size {
				cell.increase_size()
			}
		}
		for mut cell in app.grid.path_to_draw {
			if cell.size != circle_size {
				cell.increase_size()
			}
		}
		app.anim_timer = time.new_stopwatch()
	}

	// Draw menu
	app.gg.draw_rect_filled(grid_width * cell_size, 0, menu_size, screen_height, gx.rgb(0, 25, 51))
	
	// Draw title
	app.gg.draw_rect_filled(grid_width * cell_size + menu_size/6, 50, menu_size-menu_size/3, 50, gx.rgb(0, 51, 102))
	app.gg.draw_text(grid_width * cell_size + menu_size / 2, 75, 'Maze Solver', text_config)

	// Draw solve button
	app.gg.draw_rect_filled(grid_width * cell_size + menu_size/6, 150, menu_size-menu_size/3, 50, gx.rgb(0, 51, 102))
	app.gg.draw_rect_empty(grid_width * cell_size + menu_size/6, 150, menu_size-menu_size/3, 50, gx.gray)
	if app.solving {
		app.gg.draw_text(grid_width * cell_size + menu_size / 2, 175, 'Pause', text_config)
	} else {
		app.gg.draw_text(grid_width * cell_size + menu_size / 2, 175, 'Solve', text_config)
	}

	// Draw reset button
	app.gg.draw_rect_filled(grid_width * cell_size + menu_size/6, 250, menu_size-menu_size/3, 50, gx.rgb(0, 51, 102))
	app.gg.draw_rect_empty(grid_width * cell_size + menu_size/6, 250, menu_size-menu_size/3, 50, gx.gray)
	app.gg.draw_text(grid_width * cell_size + menu_size / 2, 275, 'Reset', text_config)

}

fn (mut app App) solver() {
	if app.grid.found != true {
		dijkstra(app, mut app.grid)
	} else if app.path_found != true {
		path_tracer(app.grid.get_end(), mut app.grid)
		app.path_found = true
		app.draw_timer = time.new_stopwatch()
	}
}

fn path_tracer(cell Cell, mut grid Grid) {
	grid.path << cell
	if grid.get_cell(cell.parent.x, cell.parent.y) != grid.get_start() {
		path_tracer(cell.parent, mut grid)
	}
}

fn dijkstra(app App, mut grid Grid) {
	for mut neighbour in grid.get_neighbours(grid.curr.x, grid.curr.y) {
		neighbour.distance = min(neighbour.distance, grid.curr.distance + 1)
		neighbour.parent = &grid.cells[grid.curr.y][grid.curr.x]
		grid.cells[neighbour.y][neighbour.x] = neighbour
	}
	grid.cells[grid.curr.y][grid.curr.x].visited = true
	grid.visited << grid.cells[grid.curr.y][grid.curr.x]
	grid.curr = grid.get_nearest()
	if grid.curr == grid.get_end() {
		grid.found = true
	}
}

fn frame(mut app App) {
	app.gg.begin()
	if app.solving {
		app.solver()
	}
	if app.path_found {
		if app.grid.path_to_draw.len == app.grid.path.len {
			app.path_drawn = true
		} else if app.draw_timer.elapsed().milliseconds() > 25 {
			app.grid.path_to_draw << app.grid.path[app.grid.path.len - app.grid.path_to_draw.len - 1]
			app.draw_timer = time.new_stopwatch()
		}
	}
	app.display()
	app.gg.end()
}

fn click(x f32, y f32, btn gg.MouseButton, mut app App) {
	if btn == .left {
		cell_x := int(x / cell_size)
		cell_y := int(y / cell_size)

		// check if clicked on button
		if x > grid_width * cell_size + 50 && x < grid_width * cell_size + 250 && y > 150 && y < 200 {
			if app.solving == false {
				app.solving = true
			} else {
				app.solving = false
			}
		} else if x > grid_width * cell_size + 50 && x < grid_width * cell_size + 250 && y > 250 && y < 300 {
			app.grid = init_grid(grid_width, grid_height)
			app.solving = false
			app.path_found = false
		} else {
			app.grid.set_obstacle(cell_x, cell_y)
		}
	}
}

fn keydown(code gg.KeyCode, mod gg.Modifier, mut app App) {
	if code == gg.KeyCode.enter {
		if app.solving == false {
			app.solving = true
		} else {
			app.solving = false
		}
	}
}

fn min(a int, b int) int {
	if a < b {
		return a
	}
	return b
}

fn main() {
	mut app := App{
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
