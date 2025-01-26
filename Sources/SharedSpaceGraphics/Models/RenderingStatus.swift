//
//  RenderingStatus.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import Foundation

enum RenderingStatus: Int, Equatable {
    case requestedSetup
    case settingUp
    case paused
    case rendering
    case exporting
}
