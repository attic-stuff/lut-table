var mouse = mouse_wheel_up() - mouse_wheel_down();
var a = keyboard_check(ord("A"));
var b = keyboard_check(ord("B"));

if (a) {
	A = wrap_selection(A + mouse, 0, 8);
}
if (b) {
	B = wrap_selection(B + mouse, 0, 8);
}
if (keyboard_check(ord("T"))) {
	tablemix = clamp(tablemix + (mouse * 0.05), 0, 1);	
}
if (keyboard_check(ord("F"))) {
	framemix = clamp(framemix + (mouse * 0.1), 0, 1);	
}

if (a || b) {
	sidebyeside = true;
} else {
	sidebyeside = false;
}