/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A custom `ARSCNView` configured for the requirements of this project.
*/

import Foundation
import ARKit

@available(iOS 11.0, *)
class VirtualObjectARView: ARSCNView {

    // MARK: - Types

    struct HitTestRay {
        var origin: float3
        var direction: float3

        func intersectionWithHorizontalPlane(atY planeY: Float) -> float3? {
            let normalizedDirection = simd_normalize(direction)

            // Special case handling: Check if the ray is horizontal as well.
            if normalizedDirection.y == 0 {
                if origin.y == planeY {
                    /*
                     The ray is horizontal and on the plane, thus all points on the ray
                     intersect with the plane. Therefore we simply return the ray origin.
                     */
                    return origin
                } else {
                    // The ray is parallel to the plane and never intersects.
                    return nil
                }
            }

            /*
             The distance from the ray's origin to the intersection point on the plane is:
             (`pointOnPlane` - `rayOrigin`) dot `planeNormal`
             --------------------------------------------
             direction dot planeNormal
             */

            // Since we know that horizontal planes have normal (0, 1, 0), we can simplify this to:
            let distance = (planeY - origin.y) / normalizedDirection.y

            // Do not return intersections behind the ray's origin.
            if distance < 0 {
                return nil
            }

            // Return the intersection point.
            return origin + (normalizedDirection * distance)
        }

    }

    struct FeatureHitTestResult {
        var position: float3
        var distanceToRayOrigin: Float
        var featureHit: float3
        var featureDistanceToHitResult: Float
    }

    // MARK: Position Testing
    
    /// Hit tests against the `sceneView` to find an object at the provided point.
    func virtualObject(at point: CGPoint) -> VirtualObject? {
        let hitTestOptions: [SCNHitTestOption: Any] = [.boundingBoxOnly: true]
        let hitTestResults = hitTest(point, options: hitTestOptions)
        
        return hitTestResults.lazy.compactMap { result in
            return VirtualObject.existingObjectContainingNode(result.node)
        }.first
    }

    /**
     Hit tests from the provided screen position to return the most accuarte result possible.
     Returns the new world position, an anchor if one was hit, and if the hit test is considered to be on a plane.
     */
    func worldPosition(fromScreenPosition position: CGPoint, objectPosition: float3?, infinitePlane: Bool = false) -> (position: float3, planeAnchor: ARPlaneAnchor?, isOnPlane: Bool)? {
        /*
         1. Always do a hit test against exisiting plane anchors first. (If any
            such anchors exist & only within their extents.)
        */
        let planeHitTestResults = hitTest(position, types: .existingPlaneUsingExtent)
        
        if let result = planeHitTestResults.first {
            let planeHitTestPosition = result.worldTransform.translation
            let planeAnchor = result.anchor
            
            // Return immediately - this is the best possible outcome.
            return (planeHitTestPosition, planeAnchor as? ARPlaneAnchor, true)
        }
        
        /*
         2. Collect more information about the environment by hit testing against
            the feature point cloud, but do not return the result yet.
        */
        let featureHitTestResult = hitTestWithFeatures(position, coneOpeningAngleInDegrees: 18, minDistance: 0.2, maxDistance: 2.0).first
        let featurePosition = featureHitTestResult?.position

        /*
         3. If desired or necessary (no good feature hit test result): Hit test
            against an infinite, horizontal plane (ignoring the real world).
        */
        if infinitePlane || featurePosition == nil {
            if let objectPosition = objectPosition,
                let pointOnInfinitePlane = hitTestWithInfiniteHorizontalPlane(position, objectPosition) {
                return (pointOnInfinitePlane, nil, true)
            }
        }
        
        /*
         4. If available, return the result of the hit test against high quality
            features if the hit tests against infinite planes were skipped or no
            infinite plane was hit.
        */
        if let featurePosition = featurePosition {
            return (featurePosition, nil, false)
        }
        
        /*
         5. As a last resort, perform a second, unfiltered hit test against features.
            If there are no features in the scene, the result returned here will be nil.
        */
        let unfilteredFeatureHitTestResults = hitTestWithFeatures(position)
        if let result = unfilteredFeatureHitTestResults.first {
            return (result.position, nil, false)
        }
        
        return nil
    }

    // MARK: - Hit Tests

    func hitTestRayFromScreenPosition(_ point: CGPoint) -> HitTestRay? {
        guard let frame = session.currentFrame else { return nil }

        let cameraPos = frame.camera.transform.translation

        // Note: z: 1.0 will unproject() the screen position to the far clipping plane.
        let positionVec = float3(x: Float(point.x), y: Float(point.y), z: 1.0)
        let screenPosOnFarClippingPlane = unprojectPointf(positionVec)

        let rayDirection = simd_normalize(screenPosOnFarClippingPlane - cameraPos)
        return HitTestRay(origin: cameraPos, direction: rayDirection)
    }

    func hitTestWithInfiniteHorizontalPlane(_ point: CGPoint, _ pointOnPlane: float3) -> float3? {
        guard let ray = hitTestRayFromScreenPosition(point) else { return nil }

        // Do not intersect with planes above the camera or if the ray is almost parallel to the plane.
        if ray.direction.y > -0.03 {
            return nil
        }

        /*
         Return the intersection of a ray from the camera through the screen position
         with a horizontal plane at height (Y axis).
         */
        return ray.intersectionWithHorizontalPlane(atY: pointOnPlane.y)
    }

    func hitTestWithFeatures(_ point: CGPoint, coneOpeningAngleInDegrees: Float, minDistance: Float = 0, maxDistance: Float = Float.greatestFiniteMagnitude, maxResults: Int = 1) -> [FeatureHitTestResult] {

        guard let features = session.currentFrame?.rawFeaturePoints, let ray = hitTestRayFromScreenPosition(point) else {
            return []
        }

        let maxAngleInDegrees = min(coneOpeningAngleInDegrees, 360) / 2
        let maxAngle = (maxAngleInDegrees / 180) * .pi

        let results = features.points.compactMap { featurePosition -> FeatureHitTestResult? in
            let originToFeature = featurePosition - ray.origin

            let crossProduct = simd_cross(originToFeature, ray.direction)
            let featureDistanceFromResult = simd_length(crossProduct)

            let hitTestResult = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
            let hitTestResultDistance = simd_length(hitTestResult - ray.origin)

            if hitTestResultDistance < minDistance || hitTestResultDistance > maxDistance {
                // Skip this feature - it is too close or too far away.
                return nil
            }

            let originToFeatureNormalized = simd_normalize(originToFeature)
            let angleBetweenRayAndFeature = acos(simd_dot(ray.direction, originToFeatureNormalized))

            if angleBetweenRayAndFeature > maxAngle {
                // Skip this feature - is is outside of the hit test cone.
                return nil
            }

            // All tests passed: Add the hit against this feature to the results.
            return FeatureHitTestResult(position: hitTestResult,
                                        distanceToRayOrigin: hitTestResultDistance,
                                        featureHit: featurePosition,
                                        featureDistanceToHitResult: featureDistanceFromResult)
        }

        // Sort the results by feature distance to the ray origin.
        let sortedResults = results.sorted { $0.distanceToRayOrigin < $1.distanceToRayOrigin }

		let remainingResults = maxResults > 0 ? Array(sortedResults.prefix(maxResults)) : sortedResults

        return Array(remainingResults)
    }

    func hitTestWithFeatures(_ point: CGPoint) -> [FeatureHitTestResult] {
        guard let features = session.currentFrame?.rawFeaturePoints,
            let ray = hitTestRayFromScreenPosition(point) else {
                return []
        }

        /*
         Find the feature point closest to the hit test ray, then create
         a hit test result by finding the point on the ray closest to that feature.
         */
        let possibleResults = features.points.map { featurePosition in
            return FeatureHitTestResult(featurePoint: featurePosition, ray: ray)
        }
        let closestResult = possibleResults.min(by: { $0.featureDistanceToHitResult < $1.featureDistanceToHitResult })!
        return [closestResult]
    }

}

extension SCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD float3 type is helpful.
     */
    func unprojectPointf(_ point: float3) -> float3 {
        return float3(unprojectPoint(SCNVector3(point)))
    }
}

@available(iOS 11.0, *)
extension VirtualObjectARView.FeatureHitTestResult {
    /// Add a convenience initializer to `FeatureHitTestResult` for `HitTestRay`.
    /// By adding the initializer in an extension, we also get the default initializer for `FeatureHitTestResult`.
    init(featurePoint: float3, ray: VirtualObjectARView.HitTestRay) {
        self.featureHit = featurePoint
        
        let originToFeature = featurePoint - ray.origin
        self.position = ray.origin + (ray.direction * simd_dot(ray.direction, originToFeature))
        self.distanceToRayOrigin = simd_length(self.position - ray.origin)
        self.featureDistanceToHitResult = simd_length(simd_cross(originToFeature, ray.direction))
    }
}
