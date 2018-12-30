//
//  StempelkaartViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class StempelkaartViewController : UIViewController, CLLocationManagerDelegate {
    var stamps: [Stamp] = []
    var manager = CLLocationManager()
    
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var ClaimButton: UIButton!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        Container.layer.cornerRadius = 10
        Container.layer.shadowColor = UIColor.black.cgColor
        Container.layer.shadowOffset = CGSize(width: 0, height: 3)
        Container.layer.shadowRadius = 14
        Container.layer.shadowOpacity = 0.16
        
        ClaimButton.layer.cornerRadius = 10
        
        manager.delegate = self
        setUpCollectionView()
        getStamps()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(title: "Locatie", message: "Het lukte niet om je locatie te controleren, probeer het straks nog eens.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Annuleer", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setUpCollectionView() {
        CollectionView.delegate = self
        CollectionView.dataSource = self
    }
    
    @objc private func getStamps() {
        StampAPIService.getStamps()
            .responseData(completionHandler: { [weak self] (response) in
                guard let jsonData = response.data else { return }
                
                let decoder = JSONDecoder()
                let data = try? decoder.decode([Stamp].self, from: jsonData)
                
                DispatchQueue.main.async {
                    if data != nil {
                        self?.reloadStamps(newData: data!)
                    }
                }
            })
    }
    func reloadStamps(newData: [Stamp]) {
        stamps = newData
        CollectionView.reloadData()
    }
    
    @IBAction func ClaimStampButtonTapped(_ sender: Any) {
        manager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse && CLLocationManager.locationServicesEnabled() {
            manager.requestLocation()
            let location = manager.location
            let gildtLocation = CLCircularRegion.init(
                center: CLLocationCoordinate2D.init(
                    latitude: 52.3775974,
                    longitude: 4.6333507),
                radius: CLLocationDistance.init(exactly: 50)!,
                identifier: "Gildt")
            
            if gildtLocation.contains((location?.coordinate)!){
                print("At 't Gildt")
            } else {
                let alertController = UIAlertController(title: "Locatie", message: "Het lijkt er op dat je niet aanwezig bent bij 't Gildt. Probeer het later nog eens.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Annuleer", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Locatie", message: "Stempels kunnen niet worden toegekend wanneer locatiegegevens uitstaan voor 't Gildt.\n\nDe app dient te controleren of je daadwerkelijk aanwezig bent.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Instellingen", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            }))
            alertController.addAction(UIAlertAction(title: "Annuleer", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension StempelkaartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stamps.count
    }
}

extension StempelkaartViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: "StampCollectionViewCell"), for: indexPath) as! StampCollectionViewCell
        cell.item = stamps[indexPath.row]
        return cell
    }
}
