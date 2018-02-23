/*
See LICENSE folder for this sample’s licensing information.

Abstract:
ARSCNViewDelegate interactions for `ViewController`.
*/

import ARKit

@available(iOS 11.0, *)
extension ARView: ARSCNViewDelegate, ARSessionDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.mainRender()
            
            // If light estimation is enabled, update the intensity of the model's lights and the environment map
            let baseIntensity: CGFloat = 40
            let lightingEnvironment = self.sceneView.scene.lightingEnvironment
            if let lightEstimate = self.session.currentFrame?.lightEstimate {
                lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
            } else {
                lightingEnvironment.intensity = baseIntensity
            }
            
            if self.isPlaying {
                self.sceneTime += (time - self.lastSceneTime);
                self.lastSceneTime = time;
                if let delegate = self.delegate {
                    delegate.animationUpdate(time: self.sceneTime)
                }
            }
            self.sceneView.sceneTime = self.sceneTime;
        }
    }
    
    
    func mainRender() {
        self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
        let hitTestResults = sceneView.hitTest(screenCenter, types: [.existingPlane, .estimatedHorizontalPlane])
        guard let hitTestResult = hitTestResults.first else {
            return
        }
        
        if let cameraTransform = session.currentFrame?.camera.transform {
            let translation = hitTestResult.worldTransform.translation
            let x = translation.x
            let y = translation.y
            let z = translation.z
            let position = float3(x, y, z)
            for object in self.virtualObjectLoader.loadedObjects {
                if !object.isPlaced {
                    object.setPosition(position, relativeTo: cameraTransform, smoothMovement: false)
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        self.sceneView.debugOptions = []
        self.hasFoundSurface = true
        if let delegate = self.delegate {
            delegate.surfaceFound()
        }
        for object in self.virtualObjectLoader.loadedObjects {
            if !object.isAddedToScene {
                self.placeVirtualObject(object)
            } else {
                object.adjustOntoPlaneAnchor(planeAnchor, using: node)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        for object in self.virtualObjectLoader.loadedObjects {
            if !object.isAddedToScene {
                self.placeVirtualObject(object)
            } else {
                object.adjustOntoPlaneAnchor(planeAnchor, using: node)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        self.hasFoundSurface = false
        if let delegate = self.delegate {
            delegate.surfaceLost()
        }
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if let delegate = self.delegate {
            let state = camera.trackingState
            delegate.trackingQualityInfo(id: state.id, presentation: state.presentationString, recommendation: state.recommendation)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Use `flatMap(_:)` to remove optional error messages.
        let errorMessage = messages.flatMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        if let delegate = self.delegate {
            delegate.sessionInterupted()
        }
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        restartExperience()
        if let delegate = self.delegate {
            delegate.sessionInteruptedEnded()
        }
    }
}

@available(iOS 11.0, *)
extension ARCamera.TrackingState {
    var id: Int {
        switch self {
        case .notAvailable:
            return 0
        case .normal:
            return 1
        case .limited(.excessiveMotion):
            return 2
        case .limited(.insufficientFeatures):
            return 3
        case .limited(.initializing):
            return 4
        }
    }
    
    var presentationString: String {
        switch self {
        case .notAvailable:
            return "Tracking unavailable"
        case .normal:
            return "Tracking normal"
        case .limited(.excessiveMotion):
            return "Tracking limited (Eccessive motion)"
        case .limited(.insufficientFeatures):
            return "Tracking limited (Low detail)"
        case .limited(.initializing):
            return "Initializing"
        default:
            return ""
        }
    }
    
    var recommendation: String {
        switch self {
        case .limited(.excessiveMotion):
            return "Try slowing down your movement, or reset the session."
        case .limited(.insufficientFeatures):
            return "Try pointing at a flat surface, or reset the session."
        default:
            return ""
        }
    }
}
