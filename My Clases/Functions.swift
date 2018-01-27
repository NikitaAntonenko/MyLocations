//
//  Functions.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/22/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import Foundation
import Dispatch

// MARK: - Global functions ====================================================
// 1. For doing delay
func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}
// =============================================================================


// MARK: - Global constants ====================================================
// 1. Return the address 
let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()
// =============================================================================
