shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.5) = 1.5; // Start fully black
uniform float fade : hint_range(0.0, 1.0) = 0; // Controls fade-out

void fragment() {
    float dist = distance(UV.xy, vec2(0.5, 0.5)); // Distance from center
    float alpha = smoothstep(progress, progress, dist); // Soft edge effect
    COLOR.a = alpha * fade; // Apply fade to the black part
}
