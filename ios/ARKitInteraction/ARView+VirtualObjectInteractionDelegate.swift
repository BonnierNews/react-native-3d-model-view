//
//  ARView+VirtualObjectInteractionDelegate.swift
//  RCT3DModel
//
//  Created by Johan Kasperi (DN) on 2018-02-16.
//  Copyright © 2018 Facebook. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
extension ARView: VirtualObjectInteractionDelegate {
    func placeObject(object: VirtualObject) {
        object.setPlaced(true, miniatureScale: self.miniatureScale, placeOpacity: self.placeOpacity)
        if let delegate = delegate {
            delegate.placeObjectSuccess()
        }
    }
    
    func tapView() {
        if let delegate = delegate {
            delegate.tapView()
        }
    }
    
    func tapObject() {
        if let delegate = delegate {
            delegate.tapObject()
        }
    }
}
