//
//  Deal.swift
//  GildtApp
//
//  Created by Wouter Janson on 28/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation

//model created with Erik's backendAPI in mind
struct Deal: Codable {
    let id: Int
    let image: String
    let title: String
    let description: String
    let dealType: String
    let startDate: String
    let expireDate: String
    let availableAmount: Int?
    let expireDateHumanized: String
    let dealsLeft: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case title = "title"
        case description = "description"
        case dealType = "deal_type"
        case startDate = "start_date"
        case expireDate = "expire_date"
        case availableAmount = "available_amount"
        case expireDateHumanized = "expire_date_humanized"
        case dealsLeft = "deals_left"
    }
}
