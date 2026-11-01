#ifdef PIXEL
uniform Image MainTex;

void effect()
{
    vec4 texturecolor = Texel(MainTex, VaryingTexCoord.xy);

	love_Canvases[0] = texturecolor * VaryingColor;
	love_Canvases[1] = vec4(65504.0, 0.0, 0.0, 1.0);
}
#endif

#ifdef VERTEX
uniform mat4 transformProj;
uniform mat4 transform;

vec4 position(mat4 transform_projection, vec4 VertexPosition) {
	VertexPosition = (transform * vec4(VertexPosition.xyz, 1.0));

	return (transformProj * vec4(VertexPosition.xyz, 1.0)).xyzw;
}
#endif