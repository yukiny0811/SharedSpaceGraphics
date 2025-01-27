# SharedSpaceGraphics

[![License](https://img.shields.io/github/license/yukiny0811/swifty-creatives)](https://github.com/yukiny0811/SharedSpaceGraphics/blob/main/LICENSE)

__Keyframe editor for Metal graphics programmer.__   

## Overview 

SharedSpaceGraphics is a sophisticated keyframe editor tailored for Metal graphics programmers. It seamlessly integrates code-based and GUI-based video production, providing a unified platform that enhances efficiency, collaboration, and creativity in graphics development.

## Requirements

- Swift6.0

## Supported Platforms

- macOS v14

## Key Features

### Keyframe editor

Manipulate shader variables using keyframes, allowing precise control over animations and transitions. Additionally, manage camera movements effortlessly to create dynamic and engaging visual effects.

### EditableParameter

A Swift Macro that bridges your code with the graphical user interface (GUI). This feature enables seamless synchronization between programmatic parameters and their graphical counterparts, facilitating real-time adjustments and iterations.

### Input and Output Connections

Utilize Swift Macros to connect variables across different scenes. This capability supports component reuse, efficient version management, and streamlined collaborative project development, making it easier to handle complex workflows.

## Installation

Use Swift Package Manager.

```.swift
dependencies: [
.package(url: "https://github.com/yukiny0811/SharedSpaceGraphics.git", branch: "main")
]
```

```.swift
.product(name: "SharedSpaceGraphics", package: "SharedSpaceGraphics")
```

## Notes

SharedSpaceGraphics was developed to address the limitations of existing video production and creative coding tools, particularly in handling component reuse, version management, and collaborative workflows. Traditional tools often struggle with efficiency when dealing with large-scale data visualizations and complex simulations, especially in high-resolution projects like 8K video production.

Key challenges such as the need for separate software for data preprocessing, lengthy tool startup times, and repetitive adjustments hinder productivity and creativity. SharedSpaceGraphics overcomes these obstacles by providing an integrated environment where both GUI-based controls and code-based programming coexist. This unified approach allows for efficient parameter adjustments, camera control, and complex data handling within a single tool, significantly enhancing the overall video production process.

By leveraging the strengths of both graphical interfaces and programmable logic, SharedSpaceGraphics offers a versatile and powerful solution for modern graphics programmers, enabling them to create high-quality visuals with greater ease and flexibility.

## Credits
- SharedSpaceGraphics library is created by Yuki Kuwashima
- twitter: [@yukiny_sfc](https://twitter.com/yukiny_sfc)
- [email](yukiny0811@gmail.com)
