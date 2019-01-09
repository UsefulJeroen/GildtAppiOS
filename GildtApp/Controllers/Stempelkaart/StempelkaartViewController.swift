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
import SwiftLocation

class StempelkaartViewController : UIViewController {
    var stamps: [Stamp] = []

    let statusAlertService = StatusAlertService()
    
    let gildtLocation = CLCircularRegion.init(
        center: CLLocationCoordinate2D.init(
            latitude: 52.3775974,
            longitude: 4.6333507),
        radius: CLLocationDistance.init(exactly: 150)!,
        identifier: "Gildt")


    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var ClaimButton: GildtButton!
    
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
        
        setUpCollectionView()
        getStamps()
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
        ClaimButton.showLoading()
        getAndProccessUserLocation()
    }
    
    func claimStamp(qrCode: String) {
        StampAPIService.claimStamp(qrCode: qrCode)
            .responseData(completionHandler: { [weak self] (response) in
                DispatchQueue.main.async {
                    if (response.response?.statusCode == 200) {
                        self?.getStamps()
                        self?.statusAlertService.showStatusAlert(
                            withImage: #imageLiteral(resourceName: "TabStempelkaart"),
                            title: "Stempel geclaimed",
                            message: "Veel plezier op het feest!")
                    } else {
                        self?.statusAlertService.showStatusAlert(
                            withImage: #imageLiteral(resourceName: "IconError"),
                            title: "Whoops!",
                            message: "Er ging iets mis tijdens het claimen van je stempel",
                            error: true)
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

// Location Stuff
extension StempelkaartViewController {
    func getAndProccessUserLocation() {
        SwiftLocation.Locator.currentPosition(
            accuracy:   .block,
            onSuccess:  {location in self.checkGildtDistance(from: location)},
            onFail:     {error, last in self.LocationFailureHandling()})
    }
    
    func LocationFailureHandling() {
        ClaimButton.hideLoading()
        let alertController = UIAlertController(
            title: "Locatie",
            message: "Stempels kunnen niet worden toegekend wanneer locatiegegevens uitstaan voor 't Gildt.\n\nDe app dient te controleren of je daadwerkelijk aanwezig bent.",
            preferredStyle: .alert)
        
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
    
    func checkGildtDistance(from location: CLLocation) {
        if gildtLocation.contains(location.coordinate) {
            ClaimButton.hideLoading()
            if checkScanPermissions() {
                readerVC.modalPresentationStyle = .formSheet
                readerVC.delegate               = self
                present(readerVC, animated: true, completion: nil)
            }
        } else {
            ClaimButton.hideLoading()
            statusAlertService.showStatusAlert(
                withImage: #imageLiteral(resourceName: "IconError"),
                title: "Whoops!",
                message: "Het lijkt er op dat je niet in 't Gildt bent.",
                error: true)
        }
    }
}

// QR Stuff
extension StempelkaartViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            self?.claimStamp(qrCode: result.value)
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
