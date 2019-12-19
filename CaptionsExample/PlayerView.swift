//
//  PlayerView.swift
//  CaptionsExample
//
//  Created by Gabriele Pregadio on 12/19/19.
//  Copyright © 2019 Gabe. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerView: UIView {
    var player: AVPlayer? {
        get { return playerLayer.player }
        set { playerLayer.player = newValue }
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
}
