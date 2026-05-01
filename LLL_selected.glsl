// Blue border around the current focused window. No effect when unfocused.

const vec3  BORDER_COLOR     = vec3(0.2, 0.5, 1.0);
const float BORDER_THICKNESS = 2.0;  // hard border pixels
const float GLOW_RADIUS      = 16.0; // soft glow falloff in pixels
const float GLOW_STRENGTH    = 0.55;
const float BORDER_OPACITY   = 0.85;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    if (iFocus == 0) return;

    float px = fragCoord.x;
    float py = fragCoord.y;
    float w  = iResolution.x;
    float h  = iResolution.y;

    // Distance from each edge (positive = inside window)
    float dl = px;
    float dr = w - px;
    float db = py;
    float dt = h - py;
    float edgeDist = min(min(dl, dr), min(db, dt));

    // Hard border
    if (edgeDist < BORDER_THICKNESS) {
        // Fade at corners
        float cornerDist = min(min(dl, dr), min(db, dt));
        float corner = clamp(cornerDist / BORDER_THICKNESS * 2.0, 0.0, 1.0);
        fragColor.rgb = mix(fragColor.rgb, BORDER_COLOR, BORDER_OPACITY * corner);
        return;
    }

    // Soft glow inward from the border
    float glowDist = edgeDist - BORDER_THICKNESS;
    if (glowDist < GLOW_RADIUS) {
        float t = 1.0 - glowDist / GLOW_RADIUS;
        float glow = t * t * GLOW_STRENGTH; // quadratic falloff
        fragColor.rgb = mix(fragColor.rgb, BORDER_COLOR, glow);
    }
}
