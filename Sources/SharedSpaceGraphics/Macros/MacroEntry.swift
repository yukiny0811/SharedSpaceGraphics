

@attached(
    extension,
    conformances: SharedSpaceScene,
    names: named(___keyframes_dict), named(___keyframes_minMaxDefault_dict), named(___keyframes_updated_date), named(__getOutputList()), named(__getInputList()), arbitrary
)
@attached(
    member,
    names: named(___keyframes_dict), named(___keyframes_minMaxDefault_dict),named(___keyframes_updated_date), named(__getOutputList()), named(__getInputList()), arbitrary
)
public macro SharedScene() = #externalMacro(module: "SharedSpaceGraphicsMacros", type: "SharedScene")

@attached(accessor)
public macro EditableParameter(min: Float, max: Float, default: Float) = #externalMacro(module: "SharedSpaceGraphicsMacros", type: "EditableParameter")

@attached(accessor, names: named(didSet))
public macro Output() = #externalMacro(module: "SharedSpaceGraphicsMacros", type: "Output")

@attached(accessor)
public macro Input() = #externalMacro(module: "SharedSpaceGraphicsMacros", type: "Input")

@attached(
    member,
    names: named(cObject), named(generateVertexDescriptor), named(memorySize)
)
public macro VertexObject() = #externalMacro(module: "SharedSpaceGraphicsMacros", type: "VertexObject")
