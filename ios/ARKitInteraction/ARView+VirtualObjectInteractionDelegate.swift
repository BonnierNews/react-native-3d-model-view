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
    func didPlaceObject() {
        if let delegate = self.delegate {
            delegate.placeObjectSuccess()
        }
    }
}
