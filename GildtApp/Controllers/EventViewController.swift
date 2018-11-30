//
//  EventViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 30/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EventViewController: UIViewController {
    @IBOutlet weak var EventContainer: UIView!
    @IBOutlet weak var EventButton: UIButton!
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventStamp: UIImageView!
    @IBOutlet weak var EventTitle: UILabel!
    @IBOutlet weak var EventDateTime: UILabel!
    @IBOutlet weak var EventAttendees: UILabel!
    @IBOutlet weak var EventDescription: UILabel!
    @IBOutlet weak var AttendeesContainer: UIView!
    @IBOutlet weak var EventAttendeesCount: UILabel!
    @IBOutlet weak var EventAttendeesList: UILabel!
    
    var event: Event? = nil
    
    override func viewDidLoad() {
        EventContainer.layer.cornerRadius = 10
        EventContainer.layer.shadowColor = UIColor.black.cgColor
        EventContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        EventContainer.layer.shadowRadius = 14
        EventContainer.layer.shadowOpacity = 0.16
        EventButton.layer.cornerRadius = 10
        
        AttendeesContainer.layer.cornerRadius = 10
        AttendeesContainer.layer.shadowColor = UIColor.black.cgColor
        AttendeesContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        AttendeesContainer.layer.shadowRadius = 14
        AttendeesContainer.layer.shadowOpacity = 0.16
        
        loadEventData()
    }
    
    func loadEventData() {
        if let event = event {
            EventImage.kf.setImage(with: URL(string: event.image))
            setAttendanceButton(attendance: event.attendance)
            EventTitle.text = "\(event.title):\n\(event.shortDescription)"
            EventStamp.isHidden = !event.themeParty
            let date = event.eventDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            EventDateTime.text = "\(formatter.string(from: date))"
            EventAttendees.text = "Nu al \(event.attendanceUsers.count) aanmeldingen!"
            EventDescription.text = event.description
            
            EventAttendeesCount.text = "\(event.attendanceUsers.count) aanmeldingen"
            EventAttendeesList.text = "\n"
            for attendee in event.attendanceUsers {
                EventAttendeesList.text?.append("- \(attendee)\n")
            }
        }
    }
    
    private func setAttendanceButton(attendance: Bool) {
        if attendance {
            EventButton.setTitle("Afmelden", for: .normal)
            EventButton.setTitleColor(UIColor.primaryGildtGreen, for: .normal)
            EventButton.backgroundColor = UIColor.white
            EventButton.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            EventButton.layer.borderWidth = 1
        } else {
            EventButton.setTitle("Aanmelden", for: .normal)
            EventButton.setTitleColor(UIColor.white, for: .normal)
            EventButton.backgroundColor = UIColor.primaryGildtGreen
            EventButton.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            EventButton.layer.borderWidth = 1
        }
    }
    
    @IBAction func AttendanceButtonTapped(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if let event = event {
            setAttendance(attendance: !event.attendance)
        }
    }
    
    func setAttendance(attendance: Bool) {
        AgendaAPIService.setAttendance(event: self.event!, attendance: attendance)
            .response(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(Event.self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.successfullySetAttendance(updatedEvent: data!)
                    }
                }
            })
    }
    
    func successfullySetAttendance(updatedEvent: Event) {
        self.event = updatedEvent
        NotificationCenter.default.post(name: Notification.Name("AttendanceIdentifier"), object: nil, userInfo: ["Event" : updatedEvent])
        self.loadEventData()
    }
}
