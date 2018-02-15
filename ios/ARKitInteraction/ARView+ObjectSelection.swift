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
        print("hej:place!")
        guard let cameraTransform = session.currentFrame?.camera.transform,
            let focusSquarePosition = focusSquare.lastPosition else {
            if let delegate = self.delegate {
                delegate.placeObjectError()
            }
            return
        }
        virtualObjectInteraction.selectedObject = virtualObject
        print("hej:place")
        virtualObject.setPosition(focusSquarePosition, relativeTo: cameraTransform, smoothMovement: false)
        updateQueue.async {
            virtualObject.isAddedToScene = true
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
        }
        if let delegate = self.delegate {
            delegate.placeObjectSuccess()
        }
    }
    
    func addVirtualObject(_ node: SCNNode) -> SCNNode {
        print("hej:addvirtual")
        let virtualObject = VirtualObject()
        for child in node.childNodes {
            virtualObject.addChildNode(child)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            self.virtualObjectLoader.loadVirtualObject(virtualObject) { (object) in
                self.placeVirtualObject(object)
            }
        })
        return virtualObject
    }
}
