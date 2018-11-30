//
//  AgendaAPIService.swift
//  GildtApp
//
//  Created by Wouter Janson on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class AgendaAPIService {
    private static let baseURL = "http://146.185.156.30/api/v1/"
    
    static func getAgendaItems() -> DataRequest {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return Alamofire.request("\(baseURL)/event", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    static func setAttendance(event: Event, attendance: Bool) -> DataRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)event/\(event.id)/attendance")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = LocalStorageService.getAuthToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        let attendance = Attendance.init(attendance: attendance)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(attendance)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        
        request.httpBody = data
        
        return Alamofire.request(request)
    }
}
