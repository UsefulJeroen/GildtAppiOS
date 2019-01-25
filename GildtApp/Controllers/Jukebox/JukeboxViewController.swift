//
//  JukeboxViewController.swift
//  GildtApp
//
//  Created by Jeroen Besse on 14/11/2018.
//  Copyright © 2018 Gildt. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class JukeboxViewController: GenericTableViewController<SongRequestTableViewCell, SongRequest> {
    
    override func getCellId() -> String {
        return R.nib.songRequestTableViewCell.name
    }
    
    override func getMainAPICall() -> DataRequest {
        return GildtAPIService.getSongRequests()
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var plusButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = R.string.localizable.jukebox_Title()
        
        //setup hide keyboard when clicking on other part of the screen (not keyboard)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.tableView.addGestureRecognizer(tapGesture)
        
        setupAddButton()
    }
    
    @objc private func hideKeyboard() {
        titleTextField.resignFirstResponder()
        artistTextField.resignFirstResponder()
    }
    
    //add gesturerecognizer to addbutton
    func setupAddButton() {
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addSongButtonTouched))
        plusButton.isUserInteractionEnabled = true
        plusButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //override reloadItems to set the row of each songRequest
    override func reloadItems(newData: [SongRequest]) {
        var newItems: [SongRequest] = []
        var i = 1
        for var song in newData {
            song.row = i
            newItems.append(song)
            i += 1
        }
        items = newItems
        finishRefreshing()
    }
    
    //if row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //when editing the titletextfield, and clicked on the return button on the keyboard
    @IBAction func titleTextFieldDidEnd(_ sender: Any) {
        titleTextField.endEditing(true)
        artistTextField.becomeFirstResponder()
    }

    //when editing the artisttextfield, and clicked on the return button on the keyboard
    @IBAction func artistTextFieldDidEnd(_ sender: Any) {
        addSong()
        artistTextField.endEditing(true)
    }
    
    @objc func addSongButtonTouched() {
        addSong()
    }
    
    func addSong() {
        let title = titleTextField.text
        let artist = artistTextField.text
        //check if title and artist are filled
        if (title != "" && artist != "") {
            if let title = title, let artist = artist {
                let song = NewSong(title: title, artist: artist)
                GildtAPIService.addSong(song: song)
                    .response(completionHandler: { [weak self] (response) in
                        
                        guard let jsonData = response.data else { return }
                        
                        let decoder = JSONDecoder()
                        let songRequest = try? decoder.decode(SongRequest.self, from: jsonData)
                        
                        DispatchQueue.main.async {
                            if let songRequest = songRequest {
                                self?.successfullyAddedSong(songRequest: songRequest)
                            }
                        }
                    })
            }
        }
        else {
            //show alert that you need to fill in the artist & title fields
            let alertTitle = R.string.localizable.jukebox_Error_Title()
            let alertMessage = R.string.localizable.jukebox_Error_Message()
            let discardText = R.string.localizable.jukebox_Error_Discard()
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            //check which field needs be be changed
            if title == "" {
                alert.addAction(UIAlertAction(title: discardText, style: .default, handler: { action in
                    self.titleTextField.becomeFirstResponder()
                }))
            }
            else {
                alert.addAction(UIAlertAction(title: discardText, style: .default, handler: { action in
                    self.artistTextField.becomeFirstResponder()
                }))
            }
            self.present(alert, animated: true)
        }
    }
    
    func successfullyAddedSong(songRequest: SongRequest) {
        var song = songRequest
        song.new = true
        items.insert(song, at: 0)
        tableView.reloadData()
        titleTextField.text = ""
        artistTextField.text = ""
        titleTextField.endEditing(true)
        artistTextField.endEditing(true)
    }
}
