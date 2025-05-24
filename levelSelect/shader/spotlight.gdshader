shader_type canvas_item;

uniform vec2 mouse_pos ;
uniform vec4 circle_color : source_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform int circle_radius : hint_range(0, 16, 1);

varying int progress_x;
varying int progress_y;

void fragment()
{
	progress_x += 1;
	if (progress_x == 1920)
	{
		progress_x = 0;
		progress_y += 1;
	}
	
    if (abs(progress_x - int(mouse_pos.x)) < circle_radius)
	{
        COLOR = vec4(0.0);
    } else {
        COLOR = circle_color;
    }
}