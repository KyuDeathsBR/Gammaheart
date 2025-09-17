extern bool vertical;
extern vec3 beam_color;
extern number time;
extern vec2 texsize;
extern number cutoffside;

number beam(vec2 uv, number max_height, number offset, number speed, number freq, number thickness, bool vertical) {
    number f = 0.0;
    if (cutoffside != 0) {
        if (vertical) {
                number height = max_height * (0.2 + min(1. - (uv.y), 1.));

                // Ramp makes the left hand side stay at/near 0
                number ramp = smoothstep(0., 2.0 / 2.0,1.5 -uv.y);
                height *= ramp;
                uv.x += sin(uv.y * 2.0 - time * 4.0 + offset) * height;
                f = thickness / abs(uv.x);
                f = pow(f, 0.65);
            } else {

                number height = max_height * (0.2 + min(1. - (uv.x), 1.));

                // Ramp makes the left hand side stay at/near 0
                number ramp = smoothstep(0., 2.0 / 2.0, uv.x);
                height *= ramp;
                uv.y += sin(uv.x * 2.0 - time * 4.0 + offset) * height;

                f = thickness / abs(uv.y);
                f = pow(f, 0.65);
            }
    }

	return f;
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec2 uv = texture_coords * texsize;
    
    number f = beam(uv, 0.2, 0., 4.0, 2.0 * 1.5, 0.01 * 0.5,vertical) + 
			  beam(uv, 0.2, time, 4.0, 2.0, 0.01,vertical) +
			  beam(uv, 0.2, time + 0.5, 4.0 + 0.2, 2.0 * 0.9, 0.01 * 0.5,vertical) + 
			  beam(uv, 0., 0., 4.0, 2.0, 0.01 * 3.0,vertical);
    
    color = vec4(beam_color*vec3(0.5,0.5,0.5),0.4) + vec4(f * beam_color, 1.0);

    return Texel(texture, texture_coords) * color;
}