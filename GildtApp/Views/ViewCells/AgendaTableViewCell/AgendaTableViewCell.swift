//
//  AgendaTableViewCell.swift
//  GildtApp
//
//  Created by Wouter Janson on 29/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit

class AgendaTableViewCell: GenericTableViewCell<Event> {
    
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Stamp: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    
    override var item: Event! {
        didSet {
            loadEventData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Container.layer.cornerRadius = 10
        Button.layer.cornerRadius = 10
        self.selectionStyle = .none
        
        // Shaddow is iffy
        Container.layer.shadowColor = UIColor.black.cgColor
        Container.layer.shadowOffset = CGSize(width: 0, height: 3)
        Container.layer.shadowRadius = 14
        Container.layer.shadowOpacity = 0.16
        Container.layer.masksToBounds = false
    }
    
    func loadEventData() {
        if let event = item {
            self.TitleLabel.text = "\(event.title):\n\(event.shortDescription)"
            let date = event.eventDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            self.DateLabel.text = "\(formatter.string(from: date))"
            self.Stamp.isHidden = !event.themeParty
            
            setAttendanceButton(attendance: event.attendance)
        }
    }
    
    @IBAction func attendanceButtonTapped(_ sender: Any) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if let event = item {
            setAttendance(attendance: !event.attendance)
        }
    }
    
    private func setAttendanceButton(attendance: Bool) {
        if attendance {
            Button.setTitle("Afmelden", for: .normal)
            Button.setTitleColor(UIColor.primaryGildtGreen, for: .normal)
            Button.backgroundColor = UIColor.white
            Button.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            Button.layer.borderWidth = 1
        } else {
            Button.setTitle("Aanmelden", for: .normal)
            Button.setTitleColor(UIColor.white, for: .normal)
            Button.backgroundColor = UIColor.primaryGildtGreen
            Button.layer.borderColor = UIColor.primaryGildtGreen.cgColor
            Button.layer.borderWidth = 1
        }
    }
    
    func setAttendance(attendance: Bool) {
        AgendaAPIService.setAttendance(event: self.item!, attendance: attendance)
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
        self.item = updatedEvent
        NotificationCenter.default.post(name: Notification.Name("AttendanceIdentifier"), object: nil, userInfo: ["Event" : updatedEvent])
        self.loadEventData()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
