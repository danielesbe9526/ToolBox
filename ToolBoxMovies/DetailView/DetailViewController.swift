//
//  DetailViewController.swift
//  ToolBoxMovies
//
//  Created by Usuario1 on 12/8/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var tittleLabel: UILabel!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var movie: Item?
    var viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movie = movie else {return}
        viewModel.downloadImage(movie: movie)
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    private func setUpUI() {
        tittleLabel.text = movie?.title
        descriptionText.text = movie?.description
        
        if let urlString = movie?.videoUrl, let url = URL(string: urlString) {
            setUPVideo(with: url)
        }
    }
    
    private func setUPVideo(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
        
        movieImage.layer.cornerRadius = movieImage.frame.height / 2
        movieImage.layer.shadowColor = UIColor.darkGray.cgColor
        movieImage.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        movieImage.layer.borderColor = UIColor.gray.cgColor
        movieImage.layer.borderWidth = 2
        movieImage.layer.shadowRadius = 5.0
        movieImage.layer.shadowOpacity = 0.9
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if playerLayer != nil {
            playerLayer.frame = videoView.bounds
        }
    }
}

extension DetailViewController: detailViewDelegate {
    func imageDownloaded() {
        self.movieImage.image = self.viewModel.image
    }
}
