//
//  ViewModel.swift
//  CaptionsExample
//
//  Created by Gabriele Pregadio on 12/19/19.
//  Copyright © 2019 Gabe. All rights reserved.
//

import AVFoundation
import UIKit

class ViewModel {
    let urls = [
        URL(string: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8")!,
        URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!,
        URL(string: "https://mnmedias.api.telequebec.tv/m3u8/29880.m3u8")!,
        URL(string: "http://184.72.239.149/vod/smil:BigBuckBunny.smil/playlist.m3u8")!,
        URL(string: "http://www.streambox.fr/playlists/test_001/stream.m3u8")!
    ]

    lazy var asset = AVAsset(url: urls[1])
    lazy var playerItem = AVPlayerItem(asset: asset)
    lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: playerItem)
        player.appliesMediaSelectionCriteriaAutomatically = false
        return player
    }()

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func listAvailableMediaOptions() {
        for characteristic in asset.availableMediaCharacteristicsWithMediaSelectionOptions {
            print(characteristic)

            // Retrieve the AVMediaSelectionGroup for the specified characteristic.
            if let group = asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                for option in group.options {
                    print("  Option: \(option.displayName)")
                }
            }
        }
    }

    var captionOptionsDisplayNames: [String] {
        guard let legibleCharacteristic = asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return [] }
        return legibleCharacteristic.options.map { $0.displayName }
    }

    func setCaption(named name: String) {
        guard let legibleCharacteristic = asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }
        guard let option = legibleCharacteristic.options.first(where: { $0.displayName == name }) else { return }
        playerItem.select(option, in: legibleCharacteristic)
    }

    // Set captions using a locale (ex. pass Locale(identifier: "en") for English)
    func setSubtitles(locale: Locale) {
        var message = "No english subtitles found"
        defer { print(message) }

        guard let group = asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }

        let options = AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
        if let option = options.first {
            message = "Found english subtitles"
            playerItem.select(option, in: group)
        }
    }

    func setTextStyleRules() {
        playerItem.textStyleRules = [AVTextStyleRule(textMarkupAttributes: [
            kCMTextMarkupAttribute_ForegroundColorARGB as String: [1, 1, 0, 0]
        ])!]
    }
}
