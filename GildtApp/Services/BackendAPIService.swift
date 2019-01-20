//
//  BackendAPIService.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Kingfisher
import SKPhotoBrowser
import Photos

//bakendapiservice to implement alamofire requests
//this will depend on the api made by Erik

class GildtAPIService {
    
    private static let baseURL = "https://gildt.inholland-informatica.nl/api/v1"
    
    //create a datarequest with a body
    private static func createRequest<T>(endPointURL: String, httpMethod: HTTPMethod, body: T) -> DataRequest where T: Encodable {
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
    private static func createRequest(endPointURL: String, httpMethod: HTTPMethod) -> DataRequest {
        var headers: [String: String] = [:]
        if let authToken = LocalStorageService.getAuthToken() {
            headers["Authorization"] = "Bearer \(authToken)"
        }
        return Alamofire.request("\(baseURL)/\(endPointURL)", method: httpMethod, parameters: nil, encoding: URLEncoding.default, headers: headers)
    }
    
    //MARK: - Deals
    static func getDeals() -> DataRequest {
        let endPointURL = "deal"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func redeemDeal(deal: Deal) -> DataRequest {
        let endPointURL = "deal/\(deal.id)/redeem"
        return createRequest(endPointURL: endPointURL, httpMethod: .put)
    }
    
    //MARK: - Agenda
    static func getAgendaItems() -> DataRequest {
        let endPointURL = "event"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func setAttendance(event: Event, attendance: Bool) -> DataRequest {
        let endPointURL = "event/\(event.id)/attendance"
        let attendance = Attendance.init(attendance: attendance)
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: attendance)
    }
    
    //MARK: - User
    static func register(user: RegisterModel) -> DataRequest {
        let endPointURL = "user"
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: user)
    }
    
    static func login(user: LoginModel) -> DataRequest {
        let endPointURL = "user_token"
        return createRequest(endPointURL: endPointURL, httpMethod: .post, body: user)
    }
    
    //MARK: - Jukebox
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
    
    static func downvoteSong(songId: Int) -> DataRequest {
        let endPointURL = "song/\(songId)/downvote"
        return createRequest(endPointURL: endPointURL, httpMethod: .put)
    }
    
    //MARK: - Photo
    static func getAllTags() -> DataRequest {
        let endPointURL = "tag"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func getImagesFromTag(id: Int) -> DataRequest {
        let endPointURL = "tag/\(id)/images"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func uploadImage(image: UIImage, description: String, tag: Int, callback:(SessionManager.MultipartFormDataEncodingResult)-> Void) {
        let authToken = LocalStorageService.getAuthToken()
        let headers: HTTPHeaders = ["Authorization": "Bearer \(authToken)"]
        let imageData = image.jpegData(compressionQuality: 0.6)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "image", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            multipartFormData.append(description.data(using: .utf8)!, withName: "description")
            multipartFormData.append(String(tag).data(using: .utf8)!, withName: "tags")
        }, to: URL(string: "\(baseURL)/image")!,
           method: .post, headers: headers,
           encodingCompletion: callback)
    }
    
    //MARK: - Stamp
    static func getStamps() -> DataRequest {
        let endPointURL = "stamp_card"
        return createRequest(endPointURL: endPointURL, httpMethod: .get)
    }
    
    static func claimStamp(qrCode: String) -> DataRequest {
        let endPointURL = "stamp_card/\(qrCode)"
        return createRequest(endPointURL: endPointURL, httpMethod: .post)
    }
}
