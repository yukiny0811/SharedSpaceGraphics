//
//  Utils.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import Foundation

public enum Utils {
    public static func shortUUID(uuid: String) -> String {
        let processedCompositionId = uuid.lowercased().replacingOccurrences(of: "-", with: "")
        let first6DigitsOfId = processedCompositionId[processedCompositionId.startIndex..<processedCompositionId.index(processedCompositionId.startIndex, offsetBy: 6)]
        return String(first6DigitsOfId)
    }
}
