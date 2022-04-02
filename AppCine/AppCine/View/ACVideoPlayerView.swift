//
//  ACVideoPlayerView.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 2/4/22.
//

import UIKit
import AVFoundation

class ACVideoPlayerView: UIView {
    
    
    //MARK: - UI Elemetns
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        backgroundColor = .red
    }
    
    func play(with url: URL) {
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        DispatchQueue.main.async {
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.bounds
            playerLayer.contentsGravity = .resizeAspectFill
            player.play()
            self.controlsContainerView.bringToFront()
        }
    }
}
