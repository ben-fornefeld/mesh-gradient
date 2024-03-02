#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uBlend;
uniform float uNoiseIntensity;

uniform float uNumPoints;
uniform vec2 uPoints[6];
uniform vec3 uColors[6];

out vec4 fragColor;

float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Adjusted to directly use point and color without indexing
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
    if (uNumPoints > 0.0) { processPoint(uPoints[0], uColors[0], uv, blend, sum, valence); }
    if (uNumPoints > 1.0) { processPoint(uPoints[1], uColors[1], uv, blend, sum, valence); }
    if (uNumPoints > 2.0) { processPoint(uPoints[2], uColors[2], uv, blend, sum, valence); }
    if (uNumPoints > 3.0) { processPoint(uPoints[3], uColors[3], uv, blend, sum, valence); }
    if (uNumPoints > 4.0) { processPoint(uPoints[4], uColors[4], uv, blend, sum, valence); }
    if (uNumPoints > 5.0) { processPoint(uPoints[5], uColors[5], uv, blend, sum, valence); }

    if (valence != 0.0) {
        sum /= valence;
    }

    float n = noise(uv * uSize * 0.1);
    sum = mix(sum, sum * n, (uNoiseIntensity * -1.0));

    sum = pow(sum, vec3(1.0/2.2));

    fragColor = vec4(sum.xyz, 1.0);
}