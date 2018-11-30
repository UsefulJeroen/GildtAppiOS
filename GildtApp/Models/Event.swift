//
//  Event.swift
//  GildtApp
//
//  Created by Wouter Janson on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

//model created with Erik's backendAPI in mind
struct Event: Codable {
    let id: Int
    let image: String
    let title: String
    let description: String
    let shortDescription: String
    let eventDate: String
    let themeParty, attendance: Bool
    let attendanceUsers: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, image, title, description
        case shortDescription = "short_description"
        case eventDate = "event_date"
        case themeParty = "theme_party"
        case attendance
        case attendanceUsers = "attendance_users"
    }
}

struct Attendance: Codable {
    let attendance: Bool
}

