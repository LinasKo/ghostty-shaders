// Black border around the window. Always visible (no focus check).

const vec3  BORDER_COLOR     = vec3(0.0, 0.0, 0.0);
const float BORDER_THICKNESS = 2.0;
const float GLOW_RADIUS      = 9.0;
const float GLOW_STRENGTH    = 0.2;
const float BORDER_OPACITY   = 0.5;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    float px = fragCoord.x;
    float py = fragCoord.y;
    float w  = iResolution.x;
    float h  = iResolution.y;

    float dl = px;
    float dr = w - px;
    float db = py;
    float dt = h - py;
    float edgeDist = min(min(dl, dr), min(db, dt));

    if (edgeDist < BORDER_THICKNESS) {
        float cornerDist = min(min(dl, dr), min(db, dt));
        float corner = clamp(cornerDist / BORDER_THICKNESS * 2.0, 0.0, 1.0);
        fragColor.rgb = mix(fragColor.rgb, BORDER_COLOR, BORDER_OPACITY * corner);
        return;
    }

    float glowDist = edgeDist - BORDER_THICKNESS;
    if (glowDist < GLOW_RADIUS) {
        float t = 1.0 - glowDist / GLOW_RADIUS;
        float glow = t * t * GLOW_STRENGTH;
        fragColor.rgb = mix(fragColor.rgb, BORDER_COLOR, glow);
    }
}
