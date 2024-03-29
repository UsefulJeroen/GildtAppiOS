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
    @IBOutlet weak var EventButton: GildtButton!
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
        EventButton.addedTouchArea = 10
        
        AttendeesContainer.layer.cornerRadius = 10
        AttendeesContainer.layer.shadowColor = UIColor.black.cgColor
        AttendeesContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        AttendeesContainer.layer.shadowRadius = 14
        AttendeesContainer.layer.shadowOpacity = 0.16
        
        loadEventData()
    }
    
    func loadEventData() {
        if let event = event {
            navigationItem.title = event.title
            EventImage.kf.setImage(with: URL(string: event.image))
            setAttendanceButton(attendance: event.attendance)
            EventTitle.text = "\(event.title):\n\(event.shortDescription)"
            EventStamp.isHidden = !event.themeParty
            let date = event.eventDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            EventDateTime.text = "\(formatter.string(from: date))"
            EventAttendees.text =
                R.string.localizable.agenda_Already() +
                "\(event.attendanceUsers.count) " +
                R.string.localizable.agenda_Attendees()
            EventDescription.text = event.description
            
            EventAttendeesCount.text =
                "\(event.attendanceUsers.count) " +
                R.string.localizable.agenda_Attendees()
            
            EventAttendeesList.text = "\n"
            for attendee in event.attendanceUsers {
                EventAttendeesList.text?.append("- \(attendee)\n")
            }
        }
    }
    
    private func setAttendanceButton(attendance: Bool) {
        if attendance {
            EventButton.setTitle(R.string.localizable.agenda_Signoff(), for: .normal)
            EventButton.setTitleColor(UIColor.primaryGildtGreen, for: .normal)
            EventButton.backgroundColor = UIColor.white
            EventButton.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            EventButton.layer.borderWidth = 1
        } else {
            EventButton.setTitle(R.string.localizable.agenda_Signup(), for: .normal)
            EventButton.setTitleColor(UIColor.white, for: .normal)
            EventButton.backgroundColor = UIColor.primaryGildtGreen
            EventButton.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            EventButton.layer.borderWidth = 1
        }
    }
    
    @IBAction func AttendanceButtonTapped(_ sender: Any) {
        EventButton.showLoading()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if let event = event {
            setAttendance(attendance: !event.attendance)
        }
    }
    
    func setAttendance(attendance: Bool) {
        GildtAPIService.setAttendance(event: self.event!, attendance: attendance)
            .response(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode(Event.self, from: jsonData)
                
                DispatchQueue.main.async {
                    self?.EventButton.hideLoading()
                    if data != nil {
                        self?.successfullySetAttendance(updatedEvent: data!)
                    } else {
                        StatusAlertService().showStatusAlert(
                            withImage: #imageLiteral(resourceName: "IconError"),
                            title: R.string.localizable.general_Whoops(),
                            message: R.string.localizable.agenda_Signup_Error(),
                            error: true)
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
