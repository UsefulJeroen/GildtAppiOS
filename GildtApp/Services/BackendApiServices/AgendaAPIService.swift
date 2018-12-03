//
//  AgendaAPIService.swift
//  GildtApp
//
//  Created by Wouter Janson on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

final class AgendaAPIService: BackendAPIService {
    
    static func getAgendaItems() -> DataRequest {
        let headers = getAuthHeaderDict()
        return Alamofire.request("\(baseURL)/event", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    static func setAttendance(event: Event, attendance: Bool) -> DataRequest {
        let attendance = Attendance.init(attendance: attendance)
        let endPointURL = "event/\(event.id)/attendance"
        return createRequestWithBody(endPointURL: endPointURL, model: attendance)
    }
}
