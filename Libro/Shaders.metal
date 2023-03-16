//
//  Shaders.metal
//  Libro
//
//  Created by Prayash Thapa on 3/6/23.
//

#include <metal_stdlib>
using namespace metal;

/// The structure that is fed into the vertex shader.
typedef struct {
    packed_float2 position;
    packed_float4 color;
} VertexIn;

/// The output of the vertex shader, which will be fed into the fragment shader.
typedef struct {
    float4 position [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vs(uint vertexID [[vertex_id]],
                    constant VertexIn *vertices [[buffer(0)]]) {
    VertexOut out;
    out.position = float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = vertices[vertexID].position;
    
    // Both the color and the clip space position will be interpolated in this data structure
    out.color = vertices[vertexID].color;
    return out;
}

fragment float4 fs(VertexOut in [[stage_in]]) {
    return in.color;
}
