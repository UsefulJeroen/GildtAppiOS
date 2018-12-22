//
//  SongRequest.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

struct SongRequest: Codable {
    let id: Int
    let artist: String
    let title: String
    var votes: Int
    let userId: Int
    let didVote: DidVote
    var row: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case artist = "artist"
        case title = "title"
        case votes = "votes"
        case userId = "user_id"
        case didVote = "did_vote"
    }
    
    //for new songrequest on device
    init(id: Int, artist: String, title: String, votes: Int, userId: Int) {
        self.id = id
        self.artist = artist
        self.title = title
        self.votes = votes
        self.userId = userId
    }
}

enum DidVote:Int, Decodable {
    case downvote = -1
    case no = 0
    case upvote = 1
}

/////

//enum DidVote<A: Codable, B: Codable, C: Codable> {
//    case downvote(A)
//    case nope(B)
//    case upvote(C)
//}
//
//extension DidVote: Encodable {
//    enum CodingKeys: CodingKey {
//        case downvote
//        case nope
//        case upvote
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .downvote(let value):
//            try container.encode(value, forKey: .downvote)
//        case .nope(let value):
//            try container.encode(value, forKey: .nope)
//        case .upvote(let value):
//            try container.encode(value, forKey: .upvote)
//        }
//    }
//}
//
//extension DidVote: Decodable {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            let downvote = try container.decode(A.self, forKey: .downvote)
//            self = .downvote(downvote)
//        } catch {
//            do {
//                let nope = try container.decode(B.self, forKey: .nope)
//                self = .nope(nope)
//            } catch {
//                let upvote = try container.decode(C.self, forKey: .upvote)
//                self = .upvote(upvote)
//            }
//        }
//    }
//}

/////

//protocol EnumEncodable: RawRepresentable, Encodable {
//    static var defaultEncoderValue: Self { get }
//}
//
//extension EnumEncodable where RawValue: Encodable {
//    init(from encoder: Encoder) throws {
//        var value = try encoder.singleValueContainer().encode(RawValue.self)
//        self = Self(rawValue: value) ?? Self.defaultDecoderValue
//    }
//}
//
//enum DidVoteEnum: Int, EnumEncodable {
//    static var defaultEncoderValue: DidVoteEnum = .other
//
//    //static let defaultDecoderValue: DidVoteEnum = .other
//
//    case downvote = -1
//    case nope = 0
//    case upvote = 1
//    case other
//}
