#include <metal_stdlib>
#include <simd/simd.h>
#import "PointCloudTypes.h"

using namespace metal;

constexpr sampler colorSampler(mip_filter::linear, mag_filter::linear, min_filter::linear);

static simd_float4 worldPoint(simd_float2 cameraPoint,
                              float depth,
                              matrix_float3x3 cameraIntrinsicsInversed,
                              matrix_float4x4 localToWorld)
{
    const auto localPoint = cameraIntrinsicsInversed * simd_float3(cameraPoint, 1) * depth;
    const auto worldPoint = localToWorld * simd_float4(localPoint, 1);
    
    return worldPoint / worldPoint.w;
}

kernel void computePoints(constant PointCloudUniforms &uniforms [[buffer(kPointCloudUniforms)]],
                          device PointUniforms *pointUniforms [[buffer(kPointUniforms)]],
                          constant float2 *gridPoints [[buffer(kGridPoints)]],
                          texture2d<float, access::sample> depthTexture [[texture(kTextureDepth)]],
                          texture2d<unsigned int, access::sample> confidenceTexture [[texture(kTextureConfidence)]],
                          uint index [[thread_position_in_grid]])
{
    const simd_float2 gridPoint = gridPoints[index];
    
    const float2 textureCoordinate = gridPoint / uniforms.cameraResolution;
    
    const float depth = depthTexture.sample(colorSampler, textureCoordinate).r;
    
    const simd_float4 position = worldPoint(gridPoint, depth, uniforms.cameraIntrinsicsInversed, uniforms.localToWorld);
    
    const float confidence = confidenceTexture.sample(colorSampler, textureCoordinate).r;
    
    pointUniforms[index].position = simd_float3(position.x, position.y, position.z);
    pointUniforms[index].color = simd_float3(0.0, 0.0, 0.0);
    pointUniforms[index].confidence = confidence;
}
