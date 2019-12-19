//
//  ViewModel.swift
//  CaptionsExample
//
//  Created by Gabriele Pregadio on 12/19/19.
//  Copyright © 2019 Gabe. All rights reserved.
//

// Helpful links:
// https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/StreamingMediaGuide/UsingHTTPLiveStreaming/UsingHTTPLiveStreaming.html
// https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/adding_subtitles_and_alternative_audio_tracks
// https://developer.apple.com/library/archive/qa/qa1794/_index.html
// https://bitmovin.com/mpeg-dash-hls-examples-sample-streams/

import AVFoundation
import UIKit

class ViewModel {
    let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!

    lazy var asset = AVAsset(url: url)
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

    /// Set captions using a locale (ex. pass Locale(identifier: "en") for English)
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

    /// See `CMTextMarkup.h` for all options
    func setRedTextColor() {
        addTextMarkupAttributes([kCMTextMarkupAttribute_ForegroundColorARGB: [1, 1, 0, 0]])
    }

    /// See `CMTextMarkup.h` for all options
    func setBlueTextColor() {
        addTextMarkupAttributes([kCMTextMarkupAttribute_ForegroundColorARGB: [1, 0, 0, 1]])
    }

    /// See `CMTextMarkup.h` for all options
    func setItalicText() {
        addTextMarkupAttributes([kCMTextMarkupAttribute_ItalicStyle: kCFBooleanTrue!])
    }

    /// See `CMTextMarkup.h` for all options
    func setTextHeightMultiplier(_ multiplier: Double) {
        let size = multiplier * 100 as CFNumber
        addTextMarkupAttributes([kCMTextMarkupAttribute_BaseFontSizePercentageRelativeToVideoHeight: size])
    }

    /// See `CMTextMarkup.h` for all options
    func addTextMarkupAttributes(_ attributes: [CFString: Any]) {
        var currentAttributes = playerItem.textStyleRules?.first?.textMarkupAttributes ?? [:]
        for attribute in attributes {
            currentAttributes[attribute.key as String] = attribute.value
        }
        guard let styleRule = AVTextStyleRule(textMarkupAttributes: currentAttributes) else { return }
        playerItem.textStyleRules = [styleRule]
    }
}
