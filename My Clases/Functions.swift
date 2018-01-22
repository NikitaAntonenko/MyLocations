//
//  Functions.swift
//  MyLocations
//
//  Created by getTrickS2 on 1/22/18.
//  Copyright © 2018 Nik's. All rights reserved.
//

import Foundation
import Dispatch

func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}
