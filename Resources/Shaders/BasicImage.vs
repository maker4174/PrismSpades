/*
 Copyright (c) 2013 yvt
 
 This file is part of OpenSpades.
 
 OpenSpades is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 OpenSpades is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with OpenSpades.  If not, see <http://www.gnu.org/licenses/>.
 
 */


attribute vec2 positionAttribute;
attribute vec4 colorAttribute;
attribute vec2 textureCoordAttribute;

uniform vec2 invScreenSizeFactored;
uniform vec2 invTextureSize;
uniform float rotation;  // Rotation angle in radians

varying vec4 color;
varying vec2 texCoord;

void main() {
    vec2 pos = positionAttribute;

    // Apply 2D rotation matrix
    float cosTheta = cos(rotation);
    float sinTheta = sin(rotation);
    mat2 rotationMatrix = mat2(cosTheta, -sinTheta, sinTheta, cosTheta);
    pos = rotationMatrix * pos;

    // Transform to clip space
    pos = pos * invScreenSizeFactored + vec2(-1., 1.);

    gl_Position = vec4(pos, 0.5, 1.0);

    color = colorAttribute;
    texCoord = textureCoordAttribute * invTextureSize;
}


