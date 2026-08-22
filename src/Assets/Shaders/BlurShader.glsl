vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    float Shrink = -0.2;

    texture_coords = (texture_coords - 0.5) * (1.0 - Shrink) + 0.5;

    if (texture_coords.x < 0.0 || texture_coords.x > 1.0 ||
        texture_coords.y < 0.0 || texture_coords.y > 1.0)
        return vec4(0.0);

    vec2 TexelSize = 1.0 / vec2(textureSize(tex, 0));
    float Blur = 10.0;

    vec4 EndResult = vec4(0.0);
    float Samples = 0.0;

    for (float x = -Blur; x <= Blur; x++)
    {
        for (float y = -Blur; y <= Blur; y++)
        {
            vec2 uv = texture_coords + vec2(x, y) * TexelSize;
            uv = clamp(uv, vec2(0.0), vec2(1.0));

            EndResult += Texel(tex, uv);
            Samples += 1.0;
        }
    }

    EndResult /= Samples;

    return EndResult * vec4(0.0, 0.0, 0.0, 0.5) * color;
}