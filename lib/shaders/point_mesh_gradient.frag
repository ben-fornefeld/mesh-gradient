#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uNPoints;
uniform float uBlend;

uniform vec2 uPos1;
uniform vec2 uPos2;
uniform vec2 uPos3;
uniform vec2 uPos4;
uniform vec2 uPos5;
uniform vec2 uPos6;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
uniform vec3 uColor5;
uniform vec3 uColor6;

out vec4 fragColor;

void main(void)
{
	vec2 uv = FlutterFragCoord().xy / uSize;

    // parameters

    vec2 p[6];
    p[0] = uPos1;
    p[1] = uPos2;
    p[2] = uPos3;
    p[3] = uPos4;
    p[4] = uPos5;
    p[5] = uPos6;
    
    vec3 c[6];
    c[0] = uColor1;
    c[1] = uColor2;
    c[2] = uColor3;
    c[3] = uColor4;
    c[4] = uColor5;
    c[5] = uColor6;

    // calc IDW (Inverse Distance Weight) interpolation

    float n = int(uNPoints);
    
    float w[6];
    vec3 sum = vec3(0.0);
    float valence = 0.0;

    for (int i = 0; i < 6; i++) {
        if (i >= n) {
            continue;
        }
        float distance = length(uv - p[i]);
        if (distance == 0.0) { distance = 1.0; }
        float w = 1.0 / pow(distance, uBlend);
        sum += w * c[i];
        valence += w;
    }
    sum /= valence;
    
    // apply gamma 2.2 (Approx. of linear => sRGB conversion. To make perceptually linear gradient)

    sum = pow(sum, vec3(1.0/2.2));
    
    // output
    
	fragColor = vec4(sum.xyz, 1.0);
}
