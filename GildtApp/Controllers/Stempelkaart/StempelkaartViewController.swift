//
//  StempelkaartViewController.swift
//  GildtApp
//
//  Created by Wouter Janson on 11/12/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import CoreLocation
import QRCodeReader

class StempelkaartViewController : UIViewController, CLLocationManagerDelegate {
    var stamps: [Stamp] = []
    var manager = CLLocationManager()
    
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var ClaimButton: UIButton!
    
    @IBOutlet weak var CollectionView: UICollectionView!

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.cancelButtonTitle       = "Sluiten"
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    
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
//            let gildtLocation = CLCircularRegion.init(
//                center: CLLocationCoordinate2D.init(
//                    latitude: 52.3775974,
//                    longitude: 4.6333507),
//                radius: CLLocationDistance.init(exactly: 50)!,
//                identifier: "Gildt")
            let gildtLocation = CLCircularRegion.init(
                center: CLLocationCoordinate2D.init(
                    latitude: 52.4912172,
                    longitude: 4.649962),
                radius: CLLocationDistance.init(exactly: 500)!,
                identifier: "Gildt")
            
            if gildtLocation.contains((location?.coordinate)!){
                print("At 't Gildt")
                if checkScanPermissions() {
                    readerVC.modalPresentationStyle = .formSheet
                    readerVC.delegate               = self
                    present(readerVC, animated: true, completion: nil)
                }
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
    
    func claimStamp(qrCode: String) {
        StampAPIService.claimStamp(qrCode: qrCode)
            .responseData(completionHandler: { [weak self] (response) in
                DispatchQueue.main.async {
                    if (response.error == nil) {
                        self?.getStamps()
                    } else {
                        let alertController = UIAlertController(title: "Oeps", message: "Er is iets mis gegaan tijdens het claimen van de stempel...", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Annuleer", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self!.present(alertController, animated: true, completion: nil)
                    }
                }
            })
    }
}

// Card stuff
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

// QR Stuff
extension StempelkaartViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            self?.claimStamp(qrCode: result.value)
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Camera", message: "Het lijkt er op dat er geen camera toestemming is gegeven.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Instellingen", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Annuleer", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Camera", message: "QR Reader niet ondersteunt, neem contact op met de ontwikkelaar.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oke", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
}
