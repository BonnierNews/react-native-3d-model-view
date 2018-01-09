/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for handling virtual object loading and movement
*/

import UIKit
import SceneKit

@available(iOS 11.0, *)
extension ARView {
    /**
     Adds the specified virtual object to the scene, placed using
     the focus square's estimate of the world-space position
     currently corresponding to the center of the screen.
     
     - Tag: PlaceVirtualObject
     */
    func placeVirtualObject(_ virtualObject: VirtualObject) {
        guard let cameraTransform = session.currentFrame?.camera.transform,
            let focusSquarePosition = focusSquare.lastPosition else {
//            statusViewController.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
            return
        }
//        virtualObjectInteraction.selectedObject = virtualObject
//        virtualObject.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
        }
    }
    
    func addVirtualObject(_ virtualObject: VirtualObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(15)) {
            self.virtualObjectLoader.loadVirtualObject(virtualObject) { (object) in
                self.placeVirtualObject(object)
            }
        }
    }
}
