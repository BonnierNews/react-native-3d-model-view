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
        virtualObjectInteraction.selectedObject = virtualObject
        virtualObject.isAddedToScene = true
        virtualObject.setPlaced(false, miniatureScale: self.miniatureScale, placeOpacity: self.placeOpacity)
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(virtualObject)
        }
    }
    
    func addVirtualObject(_ node: SCNNode) -> SCNNode {
        let virtualObject = VirtualObject()
        for child in node.childNodes {
            virtualObject.addChildNode(child)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.virtualObjectLoader.loadVirtualObject(virtualObject) { (object) in
                self.virtualObjectInteraction.selectedObject = virtualObject
            }
        })
        return virtualObject
    }
}
