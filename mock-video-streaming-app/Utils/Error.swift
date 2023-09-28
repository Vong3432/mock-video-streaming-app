//
//  Error.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 28/09/2023.
//

import Foundation

struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
