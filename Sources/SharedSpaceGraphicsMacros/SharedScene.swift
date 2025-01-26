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

public struct SharedScene {}

extension SharedScene: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        let memberBlock = declaration.memberBlock
        let memberBlockItemList = memberBlock.members
        
        var editableParametersNameDict: [String: Float] = [:] //varname, initialvalue
        var editableParametersMinMaxDefault: [String: (min: Float, max: Float, def: Float)] = [:]
        
        for memberBlockItem in memberBlockItemList {
            if let variableDecl = memberBlockItem.decl.as(VariableDeclSyntax.self) {
                var isEditableParameter = false
                for element in variableDecl.attributes {
                    if let attribute = element.as(AttributeSyntax.self) {
                        if attribute.attributeName.trimmedDescription == "EditableParameter" {
                            isEditableParameter = true
                            break
                        }
                    }
                }
                if isEditableParameter {
                    let patternBindingList = variableDecl.bindings
                    guard let binding = patternBindingList.first else {
                        throw "binding list error"
                    }
                    guard let args = variableDecl.attributes.first?.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self) else {
                        throw "invalid argument"
                    }
                    guard args.count == 3 else {
                        throw "invalid argument count"
                    }
                    
                    let minValueString = args[args.index(args.startIndex, offsetBy: 0)].expression.trimmedDescription
                    guard let minValue = Float(minValueString) else {
                        throw "invalid min value"
                    }
                    let maxValueString = args[args.index(args.startIndex, offsetBy: 1)].expression.trimmedDescription
                    guard let maxValue = Float(maxValueString) else {
                        throw "invalid max value"
                    }
                    let defaultValueString = args[args.index(args.startIndex, offsetBy: 2)].expression.trimmedDescription
                    guard let defaultValue = Float(defaultValueString) else {
                        throw "invalid default value"
                    }
                    
                    guard let type = binding.typeAnnotation?.type.description, type == "Float" else {
                        throw "only Float is supported"
                    }
                    if let initialValueString = binding.initializer?.value.trimmedDescription, let _ = Float(initialValueString) {
                        throw "initial value is not supported"
                    }
                    editableParametersNameDict[binding.pattern.trimmedDescription] = defaultValue
                    editableParametersMinMaxDefault[binding.pattern.trimmedDescription] = (minValue, maxValue, defaultValue)
                }
            }
        }
        
        var inputParameterNames: [String] = []
        var outputParameterNamesAndValues: [String: Float] = [:]
        
        for memberBlockItem in memberBlockItemList {
            if let variableDecl = memberBlockItem.decl.as(VariableDeclSyntax.self) {
                var isOutput = false
                var isInput = false
                for element in variableDecl.attributes {
                    if let attribute = element.as(AttributeSyntax.self) {
                        if attribute.attributeName.trimmedDescription == "Output" {
                            isOutput = true
                            break
                        }
                        if attribute.attributeName.trimmedDescription == "Input" {
                            isInput = true
                            break
                        }
                    }
                }
                if isOutput {
                    for binding in variableDecl.bindings {
                        if let type = binding.typeAnnotation?.type.trimmedDescription, type == "Float" {
                            // good
                        } else {
                            throw "only Float is supported"
                        }
                        if let initialValueString = binding.initializer?.value.trimmedDescription, let initialValue = Float(initialValueString)  {
                            outputParameterNamesAndValues[binding.pattern.trimmedDescription] = initialValue
                        }
                    }
                }
                if isInput {
                    for binding in variableDecl.bindings {
                        if let type = binding.typeAnnotation?.type.description, type == "Float?" {
                            // good
                        } else {
                            throw "only Float? is supported"
                        }
                        if let initialValueString = binding.initializer?.value.trimmedDescription, let _ = Float(initialValueString) {
                            throw "initial value is not supported"
                        }
                        inputParameterNames.append(binding.pattern.trimmedDescription)
                    }
                }
            }
        }
        
        let decl1: DeclSyntax = "@Published public var ___keyframes_updated_date: Date = Date()"
        
        var initialValuesString: String = "["
        if editableParametersNameDict.keys.count == 0 {
            initialValuesString += ":"
        } else {
            for (i, key) in editableParametersNameDict.keys.enumerated() {
                initialValuesString += "\"__\(key)\":[]"
                if i != editableParametersNameDict.keys.count - 1 {
                    initialValuesString += ","
                }
            }
        }
        initialValuesString += "]"
        
        var minMaxDefaultString: String = "["
        if editableParametersMinMaxDefault.keys.count == 0 {
            minMaxDefaultString += ":"
        } else {
            for (i, key) in editableParametersMinMaxDefault.keys.enumerated() {
                let minMaxDef = editableParametersMinMaxDefault[key]!
                minMaxDefaultString += "\"__\(key)\":(\(minMaxDef.min), \(minMaxDef.max), \(minMaxDef.def))"
                if i != editableParametersMinMaxDefault.keys.count - 1 {
                    minMaxDefaultString += ","
                }
            }
        }
        minMaxDefaultString += "]"
        
        let decl3: DeclSyntax =
"""
public var ___keyframes_dict: [String: [Keyframe]] = \(raw: initialValuesString)
"""
        let decl9: DeclSyntax =
"""
        public var ___keyframes_minMaxDefault_dict: [String: (min: Float, max: Float, def: Float)] = \(raw: minMaxDefaultString)
"""
        
        var inputDecls: [DeclSyntax] = []
        for inputName in inputParameterNames {
            inputDecls.append("public let __input_\(raw: inputName) = ConnectionEndpoint(id: UUID().uuidString, value: nil, name: \"\(raw: inputName)\")")
        }
        var outputDecls: [DeclSyntax] = []
        for outputName in outputParameterNamesAndValues.keys {
            outputDecls.append("public let __output_\(raw: outputName) = ConnectionEndpoint(id: UUID().uuidString, value: \(raw: outputParameterNamesAndValues[outputName]!), name: \"\(raw: outputName)\")")
        }
        
        var inputListDescString: String = "public func __getInputList() -> [ConnectionEndpoint] { ["
        for (i, inputName) in inputParameterNames.enumerated() {
            inputListDescString += "__input_" + inputName
            if i != inputParameterNames.count - 1 {
                inputListDescString += ","
            }
        }
        inputListDescString += "]}"
        let inputListDecl: DeclSyntax = DeclSyntax(stringLiteral: inputListDescString)
        
        var outputListDeclSyntaxString: String = "public func __getOutputList() -> [ConnectionEndpoint] { ["
        for (i, outputName) in outputParameterNamesAndValues.keys.enumerated() {
            outputListDeclSyntaxString += "__output_" + outputName
            if i != outputParameterNamesAndValues.keys.count - 1 {
                outputListDeclSyntaxString += ","
            }
        }
        outputListDeclSyntaxString += "]}"
        let outputListDecl: DeclSyntax = DeclSyntax(stringLiteral: outputListDeclSyntaxString)
        
        return [decl1, decl3, decl9] + inputDecls + outputDecls + [inputListDecl, outputListDecl]
    }
}

extension SharedScene: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        if protocols.isEmpty { return [] }
        
        let thisExtension: DeclSyntax =
          """
          extension \(type.trimmed): SharedSpaceScene {}
          """
        
        guard let extensionDecl = thisExtension.as(ExtensionDeclSyntax.self) else {
            return []
        }
        
        return [extensionDecl]
    }
}
