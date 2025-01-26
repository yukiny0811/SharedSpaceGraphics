//
//  File.metal
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/26.
//

#include <metal_stdlib>
using namespace metal;

struct ResizeVertex {
    float3 position [[ attribute(0) ]];
    float2 uv [[ attribute(1) ]];
};

struct ResizeRasterizerData {
    float4 position [[ position ]];
    float2 uv;
};

vertex ResizeRasterizerData resize_vert
(
 const ResizeVertex vIn [[ stage_in ]]
 ) {
    ResizeRasterizerData rd;
    rd.position = float4(vIn.position, 1.0);
    rd.uv = vIn.uv;
    return rd;
}

fragment half4 resize_frag
(
 ResizeRasterizerData rd [[ stage_in ]],
 const texture2d<half, access::sample> tex [[ texture(0) ]]
 ) {
    constexpr sampler textureSampler (coord::normalized, address::clamp_to_edge, filter::nearest);
    half4 sampled = tex.sample(textureSampler, rd.uv);
    return sampled;
}
