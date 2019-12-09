//
//  DetailViewModel.swift
//  ToolBoxMovies
//
//  Created by Usuario1 on 12/8/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import Foundation
import UIKit

protocol detailViewDelegate {
    func imageDownloaded()
}
 
class DetailViewModel {
    
    let apiClient = APIClient()
    var image = UIImage()
    var delegate: detailViewDelegate? 
    
     func downloadImage(movie: Item){
        guard let url = URL(string: movie.imageUrl) else { return }
        self.apiClient.downloadImages(with: url) { (response) in
            switch response {
            case .succes(let image):
                self.image = image
                self.delegate?.imageDownloaded()
            case .failure(_):
                print("Error getting images")
            }
        }
    }
}
