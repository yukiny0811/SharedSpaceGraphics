//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct Output: AccessorMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        let patternBindingList = varDecl.bindings
        
        guard let binding = patternBindingList.first else {
            return []
        }
        
        let variableName = binding.pattern.trimmedDescription
        guard let type = binding.typeAnnotation?.type else {
            throw "wow error"
        }
            
        guard type.trimmedDescription == "Float" else {
            throw "type \(type) is not supported."
        }
        
        let getSetString =
"""
didSet {
    __output_\(variableName).targetEndpoint?.value = \(variableName)
}
"""
        return [
            AccessorDeclSyntax(
                stringLiteral: getSetString
            )
        ]
    }
}
