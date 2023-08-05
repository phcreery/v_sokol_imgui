module main

// import sokol
import sokol.sapp
import sokol.gfx
import libs.sokolext
// import libs.sokolext.glue
import libs.cimgui
import libs.sokolext.simgui

struct AppState {
mut:
	pass_action gfx.PassAction
}

// fn my_log(message &char, user_data voidptr) {
// 	println(message)
// }

fn frame(mut state AppState) {
	desc := simgui.SimguiFrameDesc{
		width: sapp.width()
		height: sapp.height()
		delta_time: sapp.frame_duration()
		dpi_scale: sapp.dpi_scale()
	}
	simgui.new_frame(desc)

	//=== UI CODE STARTS HERE ===
	window_pos := cimgui.ImVec2{10, 10}
	window_pivot := cimgui.ImVec2{0, 0}
	// cimgui.create_context(unsafe { nil })
	// imgui.C.ImGuiCond_Once
	cimgui.set_next_window_pos(window_pos, 1 << 1, window_pivot)
	window_size := cimgui.ImVec2{400, 100}
	// imgui.C.ImGuiCond_Once = 1 << 1
	cimgui.set_next_window_size(window_size, 1 << 1)
	// imgui.C.ImGuiWindowFlags_None = 0
	p_open := false
	cimgui.begin('Hello Dear ImGui!', &p_open, 0)
	// ImGuiColorEditFlags_None = 0
	cimgui.color_edit3('Background', &state.pass_action.colors[0].value.r, 0)
	cimgui.end()
	//=== UI CODE ENDS HERE ===

	gfx.begin_default_pass(&state.pass_action, sapp.width(), sapp.height())
	simgui.render()
	gfx.end_pass()
	gfx.commit()
}

fn cleanup(mut state AppState) {
	simgui.shutdown()
	gfx.shutdown()
}

fn event(ev &sapp.Event, mut state AppState) {
	simgui.handle_event(ev)
}

fn init(mut state AppState) {
	// logger := gfx.Logger{
	// 	// log_cb: my_log
	// 	log_cb: memory.slog
	// 	// user_data: ...
	// }
	// desc := gfx.Desc{
	// 	context: glue.sgcontext()
	// 	// logger: logger
	// }
	desc := sapp.create_desc()
	gfx.setup(&desc)
	simgui_desc := simgui.SimguiDesc{}
	simgui.setup(&simgui_desc) // TODO

	// initial clear color
	mut colors := state.pass_action.colors
	colors[0] = gfx.ColorAttachmentAction{
		action: gfx.Action.clear
		value: gfx.Color{0.0, 0.5, 1.0, 1.0}
	}
	state.pass_action = gfx.PassAction{
		colors: colors
	}
}

fn main() {
	mut color_action := gfx.ColorAttachmentAction{
		action: .clear
		value: gfx.Color{
			r: 0.3
			g: 0.3
			b: 0.32
			a: 1.0
		}
	}
	mut pass_action := gfx.PassAction{}
	pass_action.colors[0] = color_action
	state := &AppState{
		pass_action: pass_action
		// pass_action: gfx.create_clear_pass(1, 0.1, 0.1, 1.0)
	}
	// title := 'V Metal/GL Text Rendering'

	desc := sapp.Desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		cleanup_userdata_cb: cleanup
		event_userdata_cb: event
		// window_title: title.str
		// html5_canvas_name: title.str
	}

	sapp.run(&desc)
}
