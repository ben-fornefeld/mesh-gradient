#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uBlend;

uniform vec2 uPoint1;
uniform vec2 uPoint2;
uniform vec2 uPoint3;
uniform vec2 uPoint4;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;

out vec4 fragColor;

void main(void)
{
	vec2 uv = FlutterFragCoord().xy / uSize;

    // parameters
    float blend = uBlend;

    vec2 p[4];
    p[0] = uPoint1;
    p[1] = uPoint2;
    p[2] = uPoint3;
    p[3] = uPoint4;

    vec3 c[4];
    c[0] = uColor1;
    c[1] = uColor2;
    c[2] = uColor3;
    c[3] = uColor4;
    
    // calc IDW (Inverse Distance Weight) interpolation
    
    float w[4];
    vec3 sum = vec3(0.0);
    float valence = 0.0;
    for (int i = 0; i < 4; i++) {
        float distance = length(uv - p[i]);
        if (distance == 0.0) { distance = 1.0; }
        float w =  1.0 / pow(distance, blend);
        sum += w * c[i];
        valence += w;
    }
    sum /= valence;
    
    // apply gamma 2.2 (Approx. of linear => sRGB conversion. To make perceptually linear gradient)

    sum = pow(sum, vec3(1.0/2.2));
    
    // output
    
	fragColor = vec4(sum.xyz, 1.0);
}
