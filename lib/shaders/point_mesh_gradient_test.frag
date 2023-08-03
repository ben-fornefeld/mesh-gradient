#include <flutter/runtime_effect.glsl>

vec2 uSize = vec2(300, 300);

out vec4 fragColor;

vec4 grad(vec2 uv) {

    vec4 colors[4];
    colors[0] = vec4(1.0, 0.0, 0.0, 1.0);
    colors[1] = vec4(0.0, 1.0, 0.0, 1.0);
    colors[2] = vec4(0.0, 0.0, 1.0, 1.0);
    colors[3] = vec4(1.0, 0.0, 0.0, 1.0);   

    vec4 color0 = colors[0];
    vec4 color1 = colors[1];
    vec4 color2 = colors[2];
    vec4 color3 = colors[3];
 
    // coordinates
    vec2 P0 = vec2(0.1,0.1);
    vec2 P1 = vec2(0.1,0.9);
    vec2 P2 = vec2(0.9,0.1);
    vec2 P3 = vec2(0.9,0.9);
 
    vec2 Q = P0 - P2;
    vec2 R = P1 - P0;
    vec2 S = R + P2 - P3;
    vec2 T = P0 - uv;
 
    float u;
    float t;
 
    if(Q.x == 0.0 && S.x == 0.0) {
        u = -T.x/R.x;
        t = (T.y + u*R.y) / (Q.y + u*S.y);
    } else if(Q.y == 0.0 && S.y == 0.0) {
        u = -T.y/R.y;
        t = (T.x + u*R.x) / (Q.x + u*S.x);
    } else {
        float A = S.x * R.y - R.x * S.y;
        float B = S.x * T.y - T.x * S.y + Q.x*R.y - R.x*Q.y;
        float C = Q.x * T.y - T.x * Q.y;
        if(abs(A) < 0.0001) 
            u = -C/B;
        else
        u = (-B+sqrt(B*B-4.0*A*C))/(2.0*A);
        t = (T.y + u*R.y) / (Q.y + u*S.y);
    }
    u = clamp(u,0.0,1.0);
    t = clamp(t,0.0,1.0);

    t = smoothstep(0.0, 1.0, t);
    u = smoothstep(0.0, 1.0, u);
 
    vec4 colorA = mix(color0,color1,u);
    vec4 colorB = mix(color2,color3,u);
    
    return mix(colorA, colorB, t);
}

void main(void)
{
    vec2 texco = FlutterFragCoord().xy / uSize;

    vec2 points[4];
    points[0] = vec2(0.2, 0.2);
    points[1] = vec2(0.2, 0.8);
    points[2] = vec2(0.8, 0.2);
    points[3] = vec2(0.8, 0.8);

    vec2 w[4];
    w[0] = vec2(0.4, 0.2);
    w[1] = vec2(0.1, 0.3);
    w[2] = vec2(0.3, 0.5);
    w[3] = vec2(0.2, 0.1);

    float s2[4];
    s2[0] = 0.01;
    s2[1] = 0.02;
    s2[2] = 0.015;
    s2[3] = 0.03;

    vec2 p = texco * 2.0 - 1.0;
    vec2 q = vec2(0, 0);

	for (int i = 0; i < 4; i++) {
	    vec2 points_i = points[i];
	    float s2_i = s2[i];
	    vec2 w_i = w[i];
	    vec2 delta = p - points_i;
	    float distsq = dot(delta, delta);
	    float H_i = sqrt(distsq + s2_i);
	    q += H_i * w_i;
    }

    vec4 kas = grad((q + 1.0) / 2.0);

    fragColor = kas;
}