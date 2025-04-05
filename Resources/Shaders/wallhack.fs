#version 330 core
in vec3 FragPos;
in vec2 TexCoord;

out vec4 FragColor;

uniform sampler2D textureSampler;
uniform sampler2D depthTexture; // The stored depth buffer

uniform vec3 visibleColor;   // Normal color
uniform vec3 occludedColor;  // Wallhack color

void main() {
    float sceneDepth = texture(depthTexture, TexCoord).r; // Read stored depth
    float fragDepth = gl_FragCoord.z; // Current fragment depth

    vec3 finalColor = visibleColor;

    // If current depth is greater than stored depth, it's occluded
    if (fragDepth > sceneDepth + 0.0001) { 
        finalColor = occludedColor; // Change color for hidden parts
    }

    FragColor = vec4(finalColor, 1.0);
}

