shader_type canvas_item;

uniform float aspect_ratio;
uniform float darkness_level;
uniform vec3 light_color;

void fragment() {
    COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR.rgb = COLOR.rgb*darkness_level;

    // Compute distance between player and current pixel
    vec2 player_pos;
    player_pos.x = 0.5*aspect_ratio;
    player_pos.y = 0.5;
    
    vec2 world_pos;
    world_pos.x = SCREEN_UV.x*aspect_ratio;
    world_pos.y = SCREEN_UV.y;
    float dist = length(world_pos - player_pos);
    
    // Compute light strength based on that distance
    float threshold_distance = 0.3;
    float strength = 1.0 - dist/threshold_distance;
    strength = strength*2.0;
    if (strength < 0.0) {
      strength = 0.0;
    } 

    // Modify current pixel color based on the light
    COLOR.r = COLOR.r + COLOR.r*light_color.r*strength;
    COLOR.g = COLOR.g + COLOR.g*light_color.g*strength;
    COLOR.b = COLOR.b + COLOR.b*light_color.b*strength;
}