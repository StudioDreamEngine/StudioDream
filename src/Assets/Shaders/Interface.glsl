#pragma language glsl3
// Handles general support for ui effects applied by shaders (Gradients, etc), also deals with the detection of screen-space effects

#ifdef VERTEX

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}

#endif

#ifdef PIXEL

struct Gradient {
    vec4 colors[16];
    float time[16];
};

uniform Gradient gradient;
uniform lowp int gradient_length;
uniform lowp int effect_bitmask;

uniform Image MainTex;

vec4 lerp(vec4 a, vec4 b, float alpha) {
    return a + (b-a) * alpha;
}

void effect() {
    vec4 texturecolor = Texel(MainTex, VaryingTexCoord.xy);
    vec4 gradient_color = vec4(1,1,1,1);

    float gradtime = VaryingTexCoord.x;

    for(int i = 0; i < int(gradient_length); i++) {
        // Setup time
        float current_time = gradient.time[i];
        float next_time;

        // TODO: We could perhaps improve performance here if we add a dummy value at the end of the lists, preventing the need for this code
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

    vec4 out_color = texturecolor * VaryingColor * gradient_color;

    love_Canvases[0] = out_color;

    if (effect_bitmask > 0 && out_color.a > 0f) {
        love_Canvases[1] = vec4(out_color.a,0,0,1);
    } else {
        love_Canvases[1] = vec4(0,0,0,1);
    }
}

#endif