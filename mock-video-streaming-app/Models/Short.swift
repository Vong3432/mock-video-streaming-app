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
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-002",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-003",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-004",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-005",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-006",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-007",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
        Short(
            id: "s-008",
            title: "@Rideezy IS INSANE! You have to see this BIKER flying through the NÜRBURGRING NORDSCHLEIFE BTG [4K]",
            author: .mocks[0],
            videoUrl: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8",
            thumbnailUrl: "https://images.unsplash.com/photo-1569317002804-ab77bcf1bce4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dW5zcGxhc2h8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
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
