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
    let stackView = UIStackView()

    let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPlayerView()
        setUpCaptionsSelector()

        viewModel.listAvailableMediaOptions()
        viewModel.setTextStyleRules()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.player.seek(to: CMTime(seconds: 120, preferredTimescale: .max))
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

    func setUpCaptionsSelector() {
        stackView.axis = .vertical
        stackView.spacing = 8

        viewModel.captionOptionsDisplayNames.forEach { name in
            let button = UIButton()
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func buttonTapped(_ button: UIButton) {
        let captionOptionName = button.currentTitle!
        viewModel.setCaption(named: captionOptionName)
    }
}
