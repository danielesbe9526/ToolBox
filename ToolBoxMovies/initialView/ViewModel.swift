//
//  ViewModel.swift
//  ToolBoxMovies
//
//  Created by Usuario1 on 12/7/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import Foundation
import Alamofire

protocol moviesDelegate {
    func imagesAlreadyLoaded()
}

class ViewModel {
    
    enum Config {
        static let keyUserDefaults = "Token"
    }
    
    let apiClient = APIClient()
    var token: TokenModel?
    var movies: Movies?
    var delegate: moviesDelegate?
    var images = [UIImage]()
    var images2 = [UIImage]()
    
    fileprivate func fillImages(_ movies: (Movies), category: Int) {
        let items = movies[category].items
        
        switch category {
        case 0:
            self.images = Array(repeating: UIImage(), count: items.count)
        case 1:
            self.images2 = Array(repeating: UIImage(), count: items.count)
        default:
            break
        }
        
        self.downloadImages(movies: items, category: category)
    }
    
    func loadMovies() {
        if let token = UserDefaults.standard.string(forKey: Config.keyUserDefaults ) {
            self.apiClient.obtainMovies(token: token) { (response) in
                switch response {
                case .succes(let movies):
                    self.movies = movies
                    
                    for n in 0..<movies.count {
                        self.fillImages(movies, category: n)
                    }

                case .failure(_):
                    self.generateToken()
                }
            }
        } else {
            generateToken()
        }
    }
    
    func generateToken() {
        apiClient.obtainToken { (response) in
            switch response {
            case .succes(let responseToken):
                self.token = responseToken
                UserDefaults.standard.set(responseToken.token, forKey: Config.keyUserDefaults)
                self.loadMovies()
            case .failure(_):
                break
            }
        }
    }
    
    private func downloadImages(movies: [Item], category: Int){
        var position = 0
        
        movies.forEach { (item) in
            guard let url = URL(string: item.imageUrl) else { return }
            self.apiClient.downloadImages(with: url) { (response) in
                switch response {
                case .succes(let image):
                    
                    switch category {
                    case 0:
                        self.images[position] = image
                    case 1:
                        self.images2[position] = image
                    default:
                        break
                    }
                
                    position += 1
                    
                case .failure(_):
                    print("Error getting images")
                }
                
                self.delegate?.imagesAlreadyLoaded()
            }
        }
    }

    func getSecondMoviesModel(category: Int) -> [Item] {
        let emptyItem = [Item]()
        guard let items = movies?[category].items else {return emptyItem}
        return items
    }
}

