// Handles general support for ui effects applied by shaders (Gradients, etc)

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor * color;
}