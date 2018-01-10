/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

@available(iOS 11.0, *)
@objc protocol ARViewDelegate: class {
    func start()
    func surfaceFound()
    func surfaceLost()
    func trackingQualityInfo(id: Int, presentation: String?, recommendation: String?)
    func sessionInterupted()
    func sessionInteruptedEnded()
    func placeObjectSuccess()
    func placeObjectError()
}

@available(iOS 11.0, *)
class ARView: UIView {
    
    // MARK: - Delegate
    var delegate: ARViewDelegate?
    
    // MARK: - UI Elements
    var sceneView: VirtualObjectARView!
    let focusSquare = FocusSquare()
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    var virtualObjectInteraction: VirtualObjectInteraction!
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "RCT3DModel.serialSceneKitQueue")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
        
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sceneView = VirtualObjectARView(frame: self.frame)
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.backgroundColor = UIColor.clear
        self.addSubview(sceneView)
        
        // Set up scene content.
        setupCamera()
        sceneView.scene.rootNode.addChildNode(self.focusSquare)
        sceneView.automaticallyUpdatesLighting = true
        
        virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the `ARSession`.
        resetTracking()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        session.pause()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sceneView.frame = self.bounds
    }

    // MARK: - Scene content setup

    func setupCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }

        /*
         Enable HDR camera settings for the most realistic appearance
         with environmental lighting and physically based materials.
         */
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
	func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
		session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        if let delegate = self.delegate {
            delegate.start()
        }
	}

    // MARK: - Focus Square

	func updateFocusSquare() {
        let isObjectVisible = virtualObjectLoader.loadedObjects.contains { object in
            return sceneView.isNode(object, insideFrustumOf: sceneView.pointOfView!)
        }
        
        if isObjectVisible {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
        }
        
        // We should always have a valid world position unless the sceen is just being initialized.
        guard let (worldPosition, planeAnchor, _) = sceneView.worldPosition(fromScreenPosition: screenCenter, objectPosition: focusSquare.lastPosition) else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
            if let delegate = self.delegate {
                delegate.surfaceLost()
            }
            return
        }
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
            let camera = self.session.currentFrame?.camera
            
            if let planeAnchor = planeAnchor {
                self.focusSquare.state = .planeDetected(anchorPosition: worldPosition, planeAnchor: planeAnchor, camera: camera)
            } else {
                self.focusSquare.state = .featuresDetected(anchorPosition: worldPosition, camera: camera)
            }
        }
        if let delegate = self.delegate {
            delegate.surfaceFound()
        }
	}
    
	// MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Blur the background.
        
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
    }

}
