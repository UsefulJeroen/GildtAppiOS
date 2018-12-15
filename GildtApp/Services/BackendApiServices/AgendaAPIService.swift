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
        let endPointURL = "event"
        return createRequest(endPointURL: endPointURL)
    }
    
    static func setAttendance(event: Event, attendance: Bool) -> DataRequest {
        let endPointURL = "event/\(event.id)/attendance"
        let attendance = Attendance.init(attendance: attendance)
        return createRequest(endPointURL: endPointURL, model: attendance)
    }
}
