shader_type canvas_item;

// Chroma key color (default: green)
uniform vec3 chroma_key_color : source_color = vec3(0.0, 1.0, 0.0);
uniform float threshold : hint_range(0.0, 1.0) = 0.3;
uniform float smoothness : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Calculate the difference between the pixel and the chroma key color
    float diff = length(color.rgb - chroma_key_color);
    
    // Use smoothstep to create a gradual fade effect
    float alpha = smoothstep(threshold, threshold + smoothness, diff);
    
    // Apply the alpha channel (makes green pixels transparent)
    COLOR = vec4(color.rgb, alpha);
}
