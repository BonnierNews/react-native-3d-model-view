/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UI Actions for the main view controller.
*/

import UIKit
import SceneKit

@available(iOS 11.0, *)
extension ARView: UIGestureRecognizerDelegate {
    
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
            if let directory = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("rct-3d-model-view", isDirectory: true),
                let imageData = UIImagePNGRepresentation(image) {
                let baseName = "rct-3d-model-view-"
                let fileExtension = ".png"
                var index = 1
                var url = directory.appendingPathComponent("\(baseName)\(index)\(fileExtension)")
                while FileManager.default.fileExists(atPath: url.path) {
                    index += 1
                    url = directory.appendingPathComponent("\(baseName)\(index)\(fileExtension)")
                }
                do {
                    try imageData.write(to: url)
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
//        if (self.onAnimationUpdate) {
//            NSNumber *progress = [NSNumber numberWithFloat:fmod(_sceneTime, self.animationDuration) / self.animationDuration];
//            self.onAnimationUpdate(@{@"progress":progress});
//        }
    }
}
