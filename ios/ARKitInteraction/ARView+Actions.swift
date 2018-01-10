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
        guard isRestartAvailable, !virtualObjectLoader.isLoading else { return }
        isRestartAvailable = false
        
        virtualObjectLoader.removeAllVirtualObjects()
        snapshotImageCompletion = nil
        
        resetTracking()

        // Disable restart for a while in order to give the session time to restart.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
    
    func snapshot(saveToPhotoLibrary: Bool, completion: @escaping (NSURL?) -> Void) {
        let image = self.sceneView.snapshot()
        if (saveToPhotoLibrary) {
            self.snapshotImageCompletion = completion
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image), nil)
        } else {
            if let url = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("rct-3d-model-view", isDirectory: true),
                let imageData = UIImagePNGRepresentation(image) {
                do {
                    try imageData.write(to: url)
                    completion(url as NSURL)
                } catch {
                    completion(nil)
                }
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            if let completion = self.snapshotImageCompletion {
                completion(nil)
            }
        } else {
            if let completion = self.snapshotImageCompletion {
                completion(NSURL(fileURLWithPath: ""))
            }
        }
        self.snapshotImageCompletion = nil
    }
}
