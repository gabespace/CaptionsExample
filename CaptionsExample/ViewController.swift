//
//  ViewController.swift
//  CaptionsExample
//
//  Created by Gabriele Pregadio on 12/19/19.
//  Copyright © 2019 Gabe. All rights reserved.
//

import AVKit
import UIKit

class ViewController: UIViewController {
    let playerView = PlayerView()
    let languageStackView = UIStackView()
    let textStyleStackView = UIStackView()

    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPlayerView()
        setUpSelectors()

        viewModel.listAvailableMediaOptions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.player.seek(to: CMTime(seconds: 120, preferredTimescale: .max))
        viewModel.setTextHeightMultiplier(0.05)
        viewModel.play()
    }

    func setUpPlayerView() {
        playerView.player = viewModel.player
        playerView.playerLayer.videoGravity = .resizeAspect

        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: playerView.topAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setUpSelectors() {
        languageStackView.axis = .vertical
        languageStackView.spacing = 8

        viewModel.captionOptionsDisplayNames.forEach { name in
            let button = UIButton()
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(captionButtonTapped), for: .touchUpInside)
            languageStackView.addArrangedSubview(button)
        }

        textStyleStackView.axis = .vertical
        textStyleStackView.spacing = 8

        let redButton = UIButton()
        redButton.setTitle("Red", for: .normal)
        redButton.setTitleColor(.red, for: .normal)
        redButton.addTarget(self, action: #selector(toggleRedStyle), for: .touchUpInside)

        let blueButton = UIButton()
        blueButton.setTitle("Blue", for: .normal)
        blueButton.setTitleColor(.blue, for: .normal)
        blueButton.addTarget(self, action: #selector(toggleBlueStyle), for: .touchUpInside)

        let italicsButton = UIButton()
        italicsButton.setTitle("Italics", for: .normal)
        italicsButton.setTitleColor(.black, for: .normal)
        italicsButton.addTarget(self, action: #selector(toggleItalicsStyle), for: .touchUpInside)

        textStyleStackView.addArrangedSubview(redButton)
        textStyleStackView.addArrangedSubview(blueButton)
        textStyleStackView.addArrangedSubview(italicsButton)

        let stackView = UIStackView(arrangedSubviews: [languageStackView, textStyleStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func captionButtonTapped(_ button: UIButton) {
        let captionOptionName = button.currentTitle!
        viewModel.setCaption(named: captionOptionName)
    }

    @objc func toggleRedStyle() {
        viewModel.setRedTextColor()
    }

    @objc func toggleBlueStyle() {
        viewModel.setBlueTextColor()
    }

    @objc func toggleItalicsStyle() {
        viewModel.setItalicText()
    }
}
