//
//  CustomCell.swift
//  ToolBoxMovies
//
//  Created by Usuario1 on 12/7/19.
//  Copyright © 2019 danielBeltran. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {

    var configureImage: UIImage? {
        didSet {
            guard let configureImage = configureImage else {return}
            image.image = configureImage
        }
    }
    
   private let image: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "imageInitial")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true

        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
