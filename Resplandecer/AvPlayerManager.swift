//
//  AvPlayerManager.swift
//  RadioResplandecer
//
//  Created by Benito Sanchez on 1/14/21.
//  Copyright © 2021 Radio Resplandecer. All rights reserved.
//

import Foundation
import AVFoundation

class AvPlayerManager {
    
    static let manager = AvPlayerManager()
    var playerItemContext = 0
    var currentUrl: URL?
    var observer: NSObject?
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    private init() {
        do {
            try AVAudioSession.sharedInstance()
                                  .setCategory(AVAudioSession.Category.playback)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch _ as NSError { }
        } catch _ as NSError { }

    }
    
    func loadMp3File(observer: NSObject, url : URL?) {
        self.observer = observer
        currentUrl = url!
        playerItem = AVPlayerItem(url: url!)
        
        playerItem!.addObserver(observer,
                                   forKeyPath: "status",
                                   options: [.old, .new],
                                   context: &playerItemContext)
        
        player = AVPlayer(playerItem: playerItem)
    }
    
    func play()  {
        player!.play()
    }
    
    func pause() {
        player?.pause()
        player = nil
    }
    
    
    func isPlaying() -> Bool {
        if (player != nil) {
            return player!.rate != 0 && player!.error == nil
        }
        return false
    }
    
    func getCurrentUrl() -> URL? {
        return currentUrl
    }
    
    func removeObserver() {
        if (playerItem != nil) {
            if (self.observer != nil) {
                playerItem!.removeObserver(self.observer!, forKeyPath: "status")
                observer = nil
            }
        }
    }
}
