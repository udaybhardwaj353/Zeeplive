//
//  PlayVideoClass.swift
//  ZeepLive
//
//  Created by Creative Frenzy on 04/09/23.
//

import UIKit
import AVFoundation

class VideoGiftView: UIView {
    static let TAG = "VideoGiftView"
    
    private let videoContainer = UIView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        addSubview(videoContainer)
        videoContainer.frame = bounds
        videoContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Initialize and configure the AVPlayer
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainer.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        videoContainer.layer.addSublayer(playerLayer!)
    }
    
    func startVideoGift(filePath: String) {
        if filePath.isEmpty {
            return
        }
        
        guard let url = URL(string: filePath) else {
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
    }
    
    func attachView() {
        playerLayer?.frame = videoContainer.bounds
    }
    
    func detachView() {
        playerLayer?.removeFromSuperlayer()
    }
    
    func releasePlayerController() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
    }
}
