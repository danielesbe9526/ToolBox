//
//  MovieModel.swift
//  ToolBoxMovies
//
//  Created by Usuario1 on 12/7/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import Foundation

struct MovieModel: Codable {
    let title, type: String
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let imageUrl: String
    let videoUrl: String?
    let description: String
}

typealias Movies = [MovieModel]
