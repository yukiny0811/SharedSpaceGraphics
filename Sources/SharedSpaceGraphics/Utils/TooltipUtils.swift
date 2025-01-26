//
//  TooltipUtils.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUITooltip
import SwiftUI

actor TooltipUtils {
    static let tooltipConfig: TooltipConfig = {
        var config = DefaultTooltipConfig()
        config.backgroundColor = Color.black
        config.zIndex = 10000
        return config
    }()
}
