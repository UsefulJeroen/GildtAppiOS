//
//  BackendAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire

//bakendapiservice to implement alamofire requests
//this will depend on the api made by Erik,
//possibly changed if an api from an apigroup is available at launch
class BackendAPIService {
    
    private static let baseURL = "https://gildt.inholland-informatica.nl/api/v1"
    
    //create a datarequest with a body
    fileprivate static func createRequest<T>(endPointURL: String, httpMethod: HTTPMethod, body: T) -> DataRequest where T: Encodable {
        var request = URLRequest(url: URL(string: "\(baseURL)/\(endPointURL)")!)
        request.httpMethod = httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let authToken = LocalStorageService.getAuthToken() {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(body)
        let json = String(data: jsonData, encoding: .utf8)
        let data = json?.data(using: .utf8, allowLossyConversion: false)!
        request.httpBody = data
        return Alamofire.request(request)
    }

    //create a datarequest without a body
    fileprivate static func createRequest(endPointURL: String, httpMethod: HTTPMethod) -> DataRequest {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return Alamofire.request("\(baseURL)/\(endPointURL)", method: httpMethod, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
}

class DealsAPIService: BackendAPIService {
    static func getDeals() -> DataRequest {
        let endPointURL = "deal"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func redeemDeal(deal: Deal) -> DataRequest {
        let endPointURL = "deal/\(deal.id)/redeem"
        return createRequest(endPointURL: endPointURL, httpMethod: .put)
    }
}

class AgendaAPIService: BackendAPIService {
    static func getAgendaItems() -> DataRequest {
        let endPointURL = "event"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func setAttendance(event: Event, attendance: Bool) -> DataRequest {
        let endPointURL = "event/\(event.id)/attendance"
        let attendance = Attendance.init(attendance: attendance)
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: attendance)
    }
}

class UserAPIService: BackendAPIService {
    static func register(user: RegisterModel) -> DataRequest {
        let endPointURL = "user"
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: user)
    }
    
    static func login(user: LoginModel) -> DataRequest {
        let endPointURL = "user_token"
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: user)
    }
}

class JukeboxAPIService: BackendAPIService {
    static func getSongRequests() -> DataRequest {
        let endPointURL = "song"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func addSong(song: NewSong) -> DataRequest {
        let endPointURL = "song"
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: song)
    }
    
    static func upvoteSong(songId: Int) -> DataRequest {
        let endPointURL = "song/\(songId)/upvote"
        return createRequest(endPointURL: endPointURL, httpMethod: .put)
    }
}

class PhotoAPIService: BackendAPIService {
    static func getAllTags() -> DataRequest {
        let endPointURL = "tag"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func getImagesFromTag(id: Int) -> DataRequest {
        let endPointURL = "tag/\(id)/images"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
}

class StampAPIService: BackendAPIService {
    static func getStamps() -> DataRequest {
        let endPointURL = "stamp_card"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func claimStamp(qrCode: String) -> DataRequest {
        let endPointURL = "stamp_card/\(qrCode)"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
}
