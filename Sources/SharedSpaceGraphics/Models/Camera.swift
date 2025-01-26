//
//  Camera.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import simd

public struct Camera: Equatable {

    // MARK: - Public properties

    /// フレーム(スクリーン)の幅
    private(set) public var frameWidth: Float {
        didSet {
            updatePerspectiveMatrix()
        }
    }

    /// フレーム(スクリーン)の高さ
    private(set) public var frameHeight: Float {
        didSet {
            updatePerspectiveMatrix()
        }
    }

    /// 垂直方向の視野角(度数)
    private(set) public var fovInDegrees: Float {
        didSet {
            updatePerspectiveMatrix()
        }
    }

    /// カメラの手前クリップ面
    private(set) public var near: Float {
        didSet {
            updatePerspectiveMatrix()
        }
    }

    /// カメラの奥クリップ面
    private(set) public var far: Float {
        didSet {
            updatePerspectiveMatrix()
        }
    }
    
    /// カメラ位置
    private(set) public var eye: f3 {
        didSet {
            updateViewMatrix()
        }
    }
    
    /// 注視点
    private(set) public var center: f3 {
        didSet {
            updateViewMatrix()
        }
    }
    
    /// 上方向ベクトル
    private(set) public var up: f3 {
        didSet {
            updateViewMatrix()
        }
    }

    private(set) public var viewMatrix: f4x4 = .createIdentity()
    private(set) public var perspectiveMatrix: f4x4 = .createIdentity()

    // MARK: - Initializer

    public init(
        frameWidth: Float,
        frameHeight: Float,
        fovInDegrees: Float = 85,
        near: Float = 0.01,
        far: Float = 1000,
        eye: f3 = f3(0, 0, 3),
        center: f3 = f3(0, 0, 0),
        up: f3 = f3(0, 1, 0)
    ) {
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.fovInDegrees = fovInDegrees
        self.near = near
        self.far = far
        self.eye = eye
        self.center = center
        self.up = up
        
        updatePerspectiveMatrix()
        updateViewMatrix()
    }

    private mutating func updateViewMatrix() {
        viewMatrix = f4x4.createLookAt(eye: eye, center: center, up: up)
    }
    
    private mutating func updatePerspectiveMatrix() {
        perspectiveMatrix = f4x4.createPerspective(
            fov: Float.degreesToRadians(fovInDegrees),
            aspect: frameWidth / frameHeight,
            near: near,
            far: far
        )
    }

    public mutating func setFrame(width: Float, height: Float) {
        if self.frameWidth != width || self.frameHeight != height {
            self.frameWidth = width
            self.frameHeight = height
        }
    }

    public mutating func setFov(to degrees: Float) {
        self.fovInDegrees = degrees
    }

    public mutating func setLookAt(eye: f3, center: f3, up: f3) {
        self.eye = eye
        self.center = center
        self.up = up
    }
}

fileprivate extension Float {
    static func degreesToRadians(_ deg: Float) -> Self {
        return Self(deg / 360 * Float.pi * 2)
    }
}
