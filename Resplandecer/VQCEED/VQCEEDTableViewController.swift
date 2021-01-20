//
//  DeclaracionAlDiaTableViewController.swift
//  RadioResplandecer
//
//  Created by Benito Sanchez on 1/15/21.
//  Copyright © 2021 Radio Resplandecer. All rights reserved.
//

import Foundation
import UIKit


class VQCEEDTableViewController: UITableViewController {
    
    var vqceedTracks = [MusicTrack]()
    
    private func loadSampleData() {
        
        let url = URL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vT3HsRGiTn6Lu7ie99Gh85WSpmT4aOXv9mNw2n49_5eFUbEnPPpbpaAtj7Qphj4wMd8WfaFofaTVv8H/pub?gid=1203218903&single=true&output=csv")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
            guard let data = data else { return }
            var csvData = String(data: data, encoding: .utf8)!
            let parsedCSV: [String] = csvData.components(separatedBy: ",")
                        
            for i in stride(from: 7, to: parsedCSV.count - 3, by: 3)  {
                var title = ""
                var subtitle = ""
                var url = ""
                
                title = parsedCSV[i]
                url = parsedCSV[i + 1]
                subtitle = parsedCSV[i + 2]
                
        
                print("Title")
                print(title)
                print("Subtitle")
                print(subtitle)
                print("URL")
                print(url)
                
                
            
                let stuff = MusicTrack(title: title, subtitle: subtitle, url: url)
                print("STUFF")
                print(stuff)
                self.vqceedTracks += [stuff]
                print(self.vqceedTracks)
            }
            
            self.tableView.reloadData()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vqceedTracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VQCEEDTableViewCellIdentifier", for: indexPath) as? VQCEEDTableViewCell  else {
            fatalError("The dequeued cell is not an instance of HimnarioTableViewCell.")
        }
                
        cell.authorLabel.numberOfLines = 0
        cell.titleLabel.numberOfLines = 0


        let contentData = vqceedTracks[indexPath.row]
        
        cell.titleLabel.text = contentData.title
        cell.authorLabel.text = contentData.subtitle
        cell.url = contentData.url
    
        cell.layoutIfNeeded()

        return cell
    }
}
