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
    func animationUpdate(time: Double)
    func tapView()
    func tapObject()
}

@available(iOS 11.0, *)
class ARView: UIView {
    
    // MARK: - Delegate
    var delegate: ARViewDelegate?
    
    // MARK: - UI Elements
    var sceneView: VirtualObjectARView!
    
    // MARK: - Action Properties
    var snapshotImageCompletion: ((Bool, NSURL?) -> Void)?
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    var virtualObjectInteraction: VirtualObjectInteraction!
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // MARK: - VirtualObject properties
    var miniatureScale = SCNVector3(0.2, 0.2, 0.2)
    var placeOpacity = 0.2
        
    // MARK: - Animation Controller Properties
    var isPlaying = false
    var sliderProgress: Double = 0
    var lastSceneTime: Double = 0
    var sceneTime: Double = 0
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    var hasFoundSurface = false
    
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
        sceneView.automaticallyUpdatesLighting = true
        
        virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView)
        virtualObjectInteraction.delegate = self
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        session.pause()
        UIApplication.shared.isIdleTimerDisabled = false
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
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        hasFoundSurface = false
        if let delegate = self.delegate {
            delegate.start()
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
