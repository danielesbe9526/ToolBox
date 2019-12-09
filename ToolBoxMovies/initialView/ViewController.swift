//
//  ViewController.swift
//  ToolBox
//
//  Created by Usuario1 on 12/7/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Config {
        static let cellIdentifier = "MovieCell"
        static let storyBoardidentifier = "movie"
    }
    
    @IBOutlet weak var firstCollection: UICollectionView!
    @IBOutlet weak var secondCollection: UICollectionView!
    @IBOutlet weak var fistActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var secondActivyIndicator: UIActivityIndicatorView!
    var viewModel =  ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        firstCollection.delegate = self
        firstCollection.dataSource = self
        secondCollection.delegate = self
        secondCollection.dataSource = self
        
        viewModel.delegate = self
        
        firstCollection.translatesAutoresizingMaskIntoConstraints = false
        firstCollection.register(CustomCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        secondCollection.translatesAutoresizingMaskIntoConstraints = false
        secondCollection.register(CustomCell.self, forCellWithReuseIdentifier: "MovieCell")

        viewModel.loadMovies()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fistActivityIndicator.startAnimating()
        secondActivyIndicator.startAnimating()
    }
    
    func items(category: Int) -> [Item] {
        return viewModel.getSecondMoviesModel(category: category)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.firstCollection {
            return items(category: 0).count
        } else {
            return items(category: 1).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = Config.cellIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CustomCell
        let images = viewModel.images
        let images2 = viewModel.images2

        cell.layer.cornerRadius = 12
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 0.9
        
        if collectionView == self.secondCollection && images2.count > indexPath.row{
            cell.configureImage = images2[indexPath.row]
        } else if images.count > indexPath.row {
            cell.configureImage = images[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let  vc = self.storyboard?.instantiateViewController(withIdentifier: Config.storyBoardidentifier ) as! DetailViewController
        
        if collectionView == self.firstCollection {
            vc.movie = items(category: 0)[indexPath.row]
        } else {
            vc.movie = items(category: 1)[indexPath.row]
        }
        
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.firstCollection {
            return CGSize(width: 350, height: 300 )
        } else if collectionView == self.secondCollection {
            return CGSize(width: 350, height: 150 )
        }
        
        return CGSize(width: 30, height: 30)
    }
}

extension ViewController: moviesDelegate {
    
    func imagesAlreadyLoaded() {
        DispatchQueue.main.async {
            self.firstCollection.reloadData()
            self.secondCollection.reloadData()
            self.fistActivityIndicator.startAnimating()
            self.secondActivyIndicator.startAnimating()
        }
    }
}
