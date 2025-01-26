//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//


public extension Array where Element: Hashable {
    
    mutating func unique() {
        self = self.reduce(
            [],
            {
                $0.contains($1) ? $0 : $0 + [$1]
            }
        )
    }
    
}


extension [Double] {
    func chunks(ofCount c: Int) -> [Self] {
        var finalResult: [Self] = []
        var index = 0
        var temp: Self = []
        for value in self {
            temp.append(value)
            index += 1
            if index % c == 0 {
                finalResult.append(temp)
                temp = []
            }
        }
        if temp.count > 0 {
            finalResult.append(temp)
        }
        return finalResult
    }
}


