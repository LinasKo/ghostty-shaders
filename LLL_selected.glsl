// Blue border around the current focused window. No effect when unfocused.

const vec3  BORDER_COLOR     = vec3(0.2, 0.5, 1.0);
const float BORDER_THICKNESS = 3.0; // pixels
const float BORDER_OPACITY   = 0.75;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    if (iFocus == 0) return;

    float px = fragCoord.x;
    float py = fragCoord.y;
    float w  = iResolution.x;
    float h  = iResolution.y;
    float t  = BORDER_THICKNESS;

    bool onBorder = px < t || px > w - t || py < t || py > h - t;
    if (!onBorder) return;

    // Fade at corners so it looks clean
    float dx = min(px, w - px);
    float dy = min(py, h - py);
    float edge = min(dx, dy) / t;
    float alpha = BORDER_OPACITY * clamp(edge * 2.0, 0.0, 1.0);

    fragColor.rgb = mix(fragColor.rgb, BORDER_COLOR, alpha);
}
