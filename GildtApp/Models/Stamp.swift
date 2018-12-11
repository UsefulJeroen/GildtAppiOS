//
//  Stamp.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

struct Stamp: Codable {
    let id: Int
    let eventDate: String
    let eventDateHumanized: String
    let verifiedAttendance: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case eventDate = "event_date"
        case eventDateHumanized = "event_date_humanized"
        case verifiedAttendance = "verified_attendance"
    }
}
