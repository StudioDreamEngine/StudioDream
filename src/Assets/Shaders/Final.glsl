// Applies screen-space effects

const float blur_size = 8.0;
const float max_samples = (blur_size*2.0 * blur_size*2.0);

uniform Image mat_canvas;

bool sample_shadow(vec2 coords) {
    vec4 mat_sampled = Texel(mat_canvas, coords);
    return (mat_sampled.r > 0.9f);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    bool tex_in_shadow = sample_shadow(texture_coords);

    vec4 out_color = Texel(tex, texture_coords) * color;

    if (tex_in_shadow) {
        return out_color;
    }

    vec2 texel_size = 1.0 / vec2(textureSize(tex, 0));

    vec4 blur_result = vec4(0.0);
    lowp float samples = 0.0;

    /*
    for (float x = -blur_size; x <= blur_size; x++) {
        for (float y = -blur_size; y <= blur_size; y++) {
            vec2 texel_pos = texture_coords + (vec2(x,y) * texel_size);
            bool in_shadow = sample_shadow(texel_pos);
            bool in_epsilon = (x == 0.0 || y == 0.0);

            if (in_shadow && !in_epsilon) {
                samples += 1.0/abs(x) + 1.0/abs(y);
            }
        }
    }
    */

    for (float x = -blur_size; x <= blur_size; x++) {
        for (float y = -blur_size; y <= blur_size; y++) {
            vec2 texel_pos = texture_coords + (vec2(x,y) * texel_size);
            bool in_shadow = sample_shadow(texel_pos);

            if (in_shadow) {
                samples += 1.0;
            }
        }
    }

    if (samples > 0.0) {
        blur_result = vec4(0.0,0.0,0.0,samples/max_samples);
    }

    return out_color + blur_result;
}