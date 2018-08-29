//
//  ArticleTableViewCell.swift
//  Veille
//
//  Created by Anthony Da Cruz on 10/06/2018.
//  Copyright © 2018 Anthony Da Cruz. All rights reserved.
//

import Foundation
import UIKit


class ArticleCell: UICollectionViewCell {
    
    @IBOutlet weak var sumaryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    //Outlets goes here
    @IBAction func openLinkAction(_ sender: UIButton) {
        
    }
}

extension ArticleCell {
    override func prepareForReuse() {
        self.sumaryLabel.text = ""
        self.previewImageView.image = nil
    }
    
    func configure(for object: Article) {
        if let title = object.title {
            self.titleLabel.text = title
        }else {
            if object.link.baseURL == nil {
                self.titleLabel.text = object.link.absoluteString
            }else {
                self.titleLabel.text = object.link.baseURL?.absoluteString
            }
            
        }
        
        if let sumary = object.summary {
            self.sumaryLabel.text = sumary
        }
        
        
        self.dateLabel.text = object.createdDate.toIso8601()
        
        
        if let imageURL = object.image {
            imageQueue.async {
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.previewImageView.image = image
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
