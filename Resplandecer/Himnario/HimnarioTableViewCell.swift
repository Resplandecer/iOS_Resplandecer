//
//  HimnarioTableViewCell.swift
//  RadioResplandecer
//
//  Created by Benito Sanchez on 1/15/21.
//  Copyright © 2021 Radio Resplandecer. All rights reserved.
//

import UIKit
import AVFoundation


class HimnarioTableViewCell: UITableViewCell {
    
    private var playText = "Play"
    private var pauseText = "Pause"
    
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    var url: String = ""

    @IBAction func onHimnarioSongClicked(_ sender: Any) {
        if (AvPlayerManager.manager.isPlaying() && AvPlayerManager.manager.getCurrentUrl()!.absoluteString == url) {
            AvPlayerManager.manager.pause()
            playPauseButton.setTitle(playText, for: .normal)
        } else {
            print("TRY loading")
            if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let newURL = URL(string: encoded) {
                
                print(newURL)
                AvPlayerManager.manager.loadMp3File(observer: self, url: newURL)
                AvPlayerManager.manager.play()
            } else {
                print("iddn't work")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
                print("READY TO PLAY")
                if (AvPlayerManager.manager.getCurrentUrl()?.absoluteString == self.url) {
                    playPauseButton.setTitle(pauseText, for: .normal)

                } else {
                    playPauseButton.setTitle(playText, for: .normal)

                }
                break
                // Player item is ready to play.
            case .failed:
                playPauseButton.setTitle(playText, for: .normal)

                break
                // Player item failed. See error.
            case .unknown:
                break
                // Player item is not yet ready.
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}