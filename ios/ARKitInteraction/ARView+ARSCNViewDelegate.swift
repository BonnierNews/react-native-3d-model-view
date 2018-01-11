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
            self.virtualObjectInteraction.updateObjectToCurrentTrackingPosition()
            self.updateFocusSquare()
        }
        
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let baseIntensity: CGFloat = 40
        let lightingEnvironment = sceneView.scene.lightingEnvironment
        if let lightEstimate = session.currentFrame?.lightEstimate {
            lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
        } else {
            lightingEnvironment.intensity = baseIntensity
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        DispatchQueue.main.async {
//            self.statusViewController.cancelScheduledMessage(for: .planeEstimation)
//            self.statusViewController.showMessage("SURFACE DETECTED")
            if self.virtualObjectLoader.loadedObjects.isEmpty {
//                self.statusViewController.scheduleMessage("TAP + TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .contentPlacement)
            }
        }
        
        updateQueue.async {
            for object in self.virtualObjectLoader.loadedObjects {
                object.adjustOntoPlaneAnchor(planeAnchor, using: node)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        updateQueue.async {
            for object in self.virtualObjectLoader.loadedObjects {
                object.adjustOntoPlaneAnchor(planeAnchor, using: node)
            }
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
