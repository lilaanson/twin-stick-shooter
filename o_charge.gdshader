shader_type canvas_item;

uniform float glow_strength = 0.5; // Control glow intensity
uniform vec4 glow_color = vec4(1.0, 1.0, 0.5, 1.0); // Glow color

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Apply glow effect to the transparent regions
    float glow_factor = glow_strength * (1.0 - tex_color.a); // Glow on the transparent edges
    vec4 glow = glow_color * glow_factor;
    
    // Combine the original texture color with the glow
    COLOR = tex_color + glow;
}