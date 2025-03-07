//
//  BoxInfo.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/24.
//

import MetalKit

public struct BoxInfo {
    public final class VertexPoint {
        static let A: f3 = f3(x: -1.0, y:   1.0, z:   1.0)
        static let B: f3 = f3(x: -1.0, y:  -1.0, z:   1.0)
        static let C: f3 = f3(x:  1.0, y:  -1.0, z:   1.0)
        static let D: f3 = f3(x:  1.0, y:   1.0, z:   1.0)
        static let Q: f3 = f3(x: -1.0, y:   1.0, z:  -1.0)
        static let R: f3 = f3(x:  1.0, y:   1.0, z:  -1.0)
        static let S: f3 = f3(x: -1.0, y:  -1.0, z:  -1.0)
        static let T: f3 = f3(x:  1.0, y:  -1.0, z:  -1.0)
    }
    public static let primitiveType: MTLPrimitiveType = .triangle
    public static let vertices: [f3] = [
        BoxInfo.VertexPoint.A,
        BoxInfo.VertexPoint.B,
        BoxInfo.VertexPoint.C,
        BoxInfo.VertexPoint.A,
        BoxInfo.VertexPoint.C,
        BoxInfo.VertexPoint.D,
        BoxInfo.VertexPoint.R,
        BoxInfo.VertexPoint.T,
        BoxInfo.VertexPoint.S,
        BoxInfo.VertexPoint.Q,
        BoxInfo.VertexPoint.R,
        BoxInfo.VertexPoint.S,
        BoxInfo.VertexPoint.Q,
        BoxInfo.VertexPoint.S,
        BoxInfo.VertexPoint.B,
        BoxInfo.VertexPoint.Q,
        BoxInfo.VertexPoint.B,
        BoxInfo.VertexPoint.A,
        BoxInfo.VertexPoint.D,
        BoxInfo.VertexPoint.C,
        BoxInfo.VertexPoint.T,
        BoxInfo.VertexPoint.D,
        BoxInfo.VertexPoint.T,
        BoxInfo.VertexPoint.R,
        BoxInfo.VertexPoint.Q,
        BoxInfo.VertexPoint.A,
        BoxInfo.VertexPoint.D,
        BoxInfo.VertexPoint.Q,
        BoxInfo.VertexPoint.D,
        BoxInfo.VertexPoint.R,
        BoxInfo.VertexPoint.B,
        BoxInfo.VertexPoint.S,
        BoxInfo.VertexPoint.T,
        BoxInfo.VertexPoint.B,
        BoxInfo.VertexPoint.T,
        BoxInfo.VertexPoint.C
    ]
}
