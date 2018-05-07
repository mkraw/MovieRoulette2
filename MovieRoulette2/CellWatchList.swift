//
//  CellTableViewCell.swift
//  MovieRoulette2
//
//  Created by Marta Krawiec on 4/15/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//

import UIKit

class CellWatchList: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadImgWithAstring(urlString: String) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil {
                print(error!)
                return
            } else {
                DispatchQueue.main.async(execute:{
                self.posterImg.image = UIImage(data: data!)
                
                })
            }
        
        }).resume()
    }
    
    func updateUI(movieTitle: String, imgUrl: String, rating: String) {
        
        title.text = movieTitle
        let posterPath = "http://image.tmdb.org/t/p/w185//\(imgUrl)"
        loadImgWithAstring(urlString: posterPath)
        ratingLabel.text = rating 
    
    }

}
