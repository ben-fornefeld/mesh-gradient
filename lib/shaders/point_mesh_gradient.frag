#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
// uVars = (uBlend, uNoiseIntensity, uNumPoints) -> ios buffer constants limitation workaround
uniform vec3 uVars;

uniform vec2 uPoint1;
uniform vec2 uPoint2;
uniform vec2 uPoint3;
uniform vec2 uPoint4;
uniform vec2 uPoint5;
uniform vec2 uPoint6;

uniform vec3 uColor1;
uniform vec3 uColor2;
uniform vec3 uColor3;
uniform vec3 uColor4;
uniform vec3 uColor5;
uniform vec3 uColor6;

out vec4 fragColor;

float uBlend = uVars.x;
float uNoiseIntensity = uVars.y;
float uNumPoints = uVars.z;

float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void processPoint(vec2 point, vec3 color, vec2 uv, float blend, inout vec3 sum, inout float valence) {
    float distance = length(uv - point);
    if (distance == 0.0) { distance = 1.0; }
    float w = 1.0 / pow(distance, blend);
    sum += w * color;
    valence += w;
}

void main(void) {

    vec2 uv = FlutterFragCoord().xy / uSize;
    float blend = uBlend;

    vec3 sum = vec3(0.0);
    float valence = 0.0;

    // Directly pass the array elements
    if (uNumPoints > 0.0) { processPoint(uPoint1, uColor1, uv, blend, sum, valence); }
    if (uNumPoints > 1.0) { processPoint(uPoint2, uColor2, uv, blend, sum, valence); }
    if (uNumPoints > 2.0) { processPoint(uPoint3, uColor3, uv, blend, sum, valence); }
    if (uNumPoints > 3.0) { processPoint(uPoint4, uColor4, uv, blend, sum, valence); }
    if (uNumPoints > 4.0) { processPoint(uPoint5, uColor5, uv, blend, sum, valence); }
    if (uNumPoints > 5.0) { processPoint(uPoint6, uColor6, uv, blend, sum, valence); }

    if (valence != 0.0) {
        sum /= valence;
    }

    float n = noise(uv * uSize * 0.1);
    sum = mix(sum, sum * n, (uNoiseIntensity * -1.0));

    sum = pow(sum, vec3(1.0/2.2));

    fragColor = vec4(sum.xyz, 1.0);
}