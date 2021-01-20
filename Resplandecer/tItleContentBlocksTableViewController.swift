//
//  tItleContentBlocksTableViewController.swift
//  RadioResplandecer
//
//  Created by Benito Sanchez on 1/12/21.
//  Copyright © 2021 Radio Resplandecer. All rights reserved.
//

import UIKit
import AVFoundation


struct TitleContentBlocks {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}

class tItlecContentBlocksTableViewController: UITableViewController {
    
    private var pressToPlayText: String = "Precione Para Escuchar Radio"
    private var youreListeningToText : String = "Estas Escuchando Radio Resplandecer"
    
    private var playerItemContext = 0
    @IBOutlet var pressToPlayButton: UIButton!
    
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
    var titleAndContents = [TitleContentBlocks]()

    @IBAction func onPlayRadioClicked(_ sender: Any) {
        print("clicked!")
        
        if (AvPlayerManager.manager.isPlaying()) {
            AvPlayerManager.manager.pause()
            pressToPlayButton.setTitle(pressToPlayText, for: .normal)
        } else {
            AvPlayerManager.manager.loadMp3File(observer: self, url: URL(string: "http://107.215.165.202:8000/resplandecer?hash=1573611071190.mp3"))
            AvPlayerManager.manager.play()
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

        // Only handle observations for the playerItemContext
        guard context == &AvPlayerManager.manager.self.playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                pressToPlayButton.setTitle(youreListeningToText, for: .normal)
                break
                // Player item is ready to play.
            case .failed:
                

                break
                // Player item failed. See error.
            case .unknown:
                break
                // Player item is not yet ready.
            }
        }
    }
    
    
    private func loadSampleData() {
        
        let url = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vT3HsRGiTn6Lu7ie99Gh85WSpmT4aOXv9mNw2n49_5eFUbEnPPpbpaAtj7Qphj4wMd8WfaFofaTVv8H/pub?gid=939886657&single=true&output=csv")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
            guard let data = data else { return }
            var csvData = String(data: data, encoding: .utf8)!
            let parsedCSV: [String] = csvData.components(separatedBy: ",")
            
            
            for i in 5..<parsedCSV.count  {
                var title = ""
                var context = ""
                
                if (i % 2 != 0) {
                    title = parsedCSV[i]
                    context = parsedCSV[i + 1]
                }
        
                
                
                if (!title.isEmpty && !context.isEmpty) {
                    let stuff = TitleContentBlocks(title: title, content: context)
                    self.titleAndContents += [stuff]
                }
            }
            
            self.tableView.reloadData()
            self.loadingSpinner.stopAnimating()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pressToPlayButton.setTitle(pressToPlayText, for: .normal)
        
        loadSampleData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleAndContents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableViewCell", for: indexPath) as? MainTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
       
        let contentData = titleAndContents[indexPath.row]
        
        cell.titleViewCell.text = contentData.title
        cell.contentViewCell.text = contentData.content

        return cell
    }

}