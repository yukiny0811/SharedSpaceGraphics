import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension String: @retroactive Error {}
extension String: @retroactive LocalizedError {
    public var errorDescription: String? { self }
}

@main
struct EditablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SharedScene.self,
        EditableParameter.self,
        Output.self,
        Input.self,
        VertexObject.self,
    ]
}
