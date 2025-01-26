//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import simd

extension simd_float4x4: Codable {
    // Define the coding keys. Here, we're encoding the matrix as an array of columns.
    enum CodingKeys: String, CodingKey {
        case columns
    }

    // Encode the matrix by encoding its columns as an array.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let columnsArray: [simd_float4] = [
            self.columns.0,
            self.columns.1,
            self.columns.2,
            self.columns.3
        ]
        try container.encode(columnsArray, forKey: .columns)
    }

    // Decode the matrix by decoding an array of columns and initializing the matrix.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let columnsArray = try container.decode([simd_float4].self, forKey: .columns)
        
        // Ensure that exactly four columns are provided.
        guard columnsArray.count == 4 else {
            throw DecodingError.dataCorruptedError(
                forKey: .columns,
                in: container,
                debugDescription: "Expected four columns for simd_float4x4."
            )
        }
        
        self.init(columns: (
            columnsArray[0],
            columnsArray[1],
            columnsArray[2],
            columnsArray[3]
        ))
    }
}
