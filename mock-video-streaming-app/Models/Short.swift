//
//  Shorts.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import Foundation

struct Short: Identifiable, Hashable {
    let id: String
    let title: String
    let author: Author
    let videoUrl: String
    let thumbnailUrl: String
    
    static func == (lhs: Short, rhs: Short) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

struct Author: Identifiable {
    let id: String
    let username: String
    let avatar: String
    let tagline: String?
}

#if DEBUG

extension Short {
    static let mocks = [
        Short(
            id: "s-001",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "",
            thumbnailUrl: "")
    ]
}

extension Author {
    static let mocks = [
        Author(
            id: "a-001",
            username: "xthilox",
            avatar: "https://yt3.ggpht.com/ytc/AOPolaRhv_gd-rvFI0YX8EW8Wr4fUyZ-J0ZUnRkDzzK8KA=s88-c-k-c0x00ffffff-no-rj",
            tagline: "Racing"
        )
    ]
}

#endif
