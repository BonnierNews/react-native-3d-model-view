/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UI Actions for the main view controller.
*/

import UIKit
import SceneKit

@available(iOS 11.0, *)
extension ARView: UIGestureRecognizerDelegate {
    
    func start() {
        resetTracking()
    }
    
    /// - Tag: restartExperience
    func restartExperience() {
        guard isRestartAvailable else { return }
        isRestartAvailable = false
        
        virtualObjectLoader.removeAllVirtualObjects()
        
        snapshotImageCompletion = nil
        
        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
    
    func snapshot(saveToPhotoLibrary: Bool, completion: @escaping (Bool, NSURL?) -> Void) {
        let image = self.sceneView.snapshot()
        if (saveToPhotoLibrary) {
            self.snapshotImageCompletion = completion
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image), nil)
        } else {
            let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            if let imageData = UIImagePNGRepresentation(image),
                let directory = urls.first {
                let baseName = "rct-3d-model-view-"
                let fileExtension = ".png"
                var index = 1
                var url = directory.appendingPathComponent("rct-3d-model-view/\(baseName)\(index)\(fileExtension)")
                while fileManager.fileExists(atPath: url.path) {
                    index += 1
                    url = directory.appendingPathComponent("rct-3d-model-view/\(baseName)\(index)\(fileExtension)")
                }
                do {
                    try imageData.write(to: url, options: [.atomic])
                    completion(true, url as NSURL)
                } catch {
                    completion(false, nil)
                }
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            if let completion = self.snapshotImageCompletion {
                completion(false, nil)
            }
        } else {
            if let completion = self.snapshotImageCompletion {
                completion(true, nil)
            }
        }
        self.snapshotImageCompletion = nil
    }
    
    func startAnimation() {
        self.isPlaying = true
        self.sceneView.isPlaying = true
        self.lastSceneTime = CACurrentMediaTime()
    }
    
    func stopAnimation() {
        self.isPlaying = false
        self.sceneView.isPlaying = false
    }
    
    func setProgress(value: Double, animationDuration: Double) {
        self.sliderProgress = value
        self.stopAnimation()
        self.sceneTime = value * animationDuration
        self.sceneView.sceneTime = self.sceneTime
    }
    
    func setMiniature(_ miniature: Bool) {
        if let selectedObject = self.virtualObjectInteraction.selectedObject {
            selectedObject.setMiniature(miniature, miniatureScale: self.miniatureScale)
        }
    }
    
    func setMinScale(_ scale: Double) {
        self.miniatureScale = SCNVector3(scale, scale, scale)
    }
    
    func setPlaceOpac(_ opacity: Double) {
        self.placeOpacity = opacity
    }
}
