// Handles general support for ui effects applied by shaders (Gradients, etc)

struct Gradient {
    vec4 colors[16];
    float time[16];
};

uniform Gradient gradient;
uniform lowp int gradient_length;

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}

vec4 lerp(vec4 a, vec4 b, float alpha) {
    return a + (b-a) * alpha;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec4 gradient_color = vec4(1,1,1,1);

    float gradtime = texture_coords.x;

    for(int i = 0; i < int(gradient_length); i++) {
        // Setup time
        float current_time = gradient.time[i];
        float next_time;

        bool can_sample = (i == gradient_length-1);
        if (can_sample) { next_time = current_time; } else { next_time = gradient.time[i+1]; }

        // Check if we're in range
        if (!(current_time < gradtime && next_time > gradtime)) {
            continue;
        }

        // Setup color
        vec4 current_color = gradient.colors[i];
        vec4 next_color;

        if (can_sample) { next_color = current_color; } else { next_color = gradient.colors[i+1]; }

        // Find color
        gradient_color = lerp(current_color, next_color, (gradtime-current_time)/(next_time-current_time));
    }
    
    return texturecolor * color * gradient_color;
}