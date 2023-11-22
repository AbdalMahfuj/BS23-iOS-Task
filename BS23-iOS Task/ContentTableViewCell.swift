//
//  ContentTableViewCell.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit
import SDWebImage

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    static let identifier = "ContentTableViewCell"
    
    let posterPath = "https://image.tmdb.org/t/p/original"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 8.0
        movieImage.clipsToBounds = true
    }
    
    func setUI(movie: Movie) {
        nameLabel.text = movie.title
//        scoreLabel.text = "Score: " + String(format: "%0.2f", tvshow.score ?? 0.0)
//        runtimeLabel.text = "Runtime: \(tvshow.details?.runtime ?? 0.0) m"
        if let urlString = movie.poster_path, let url = URL(string: posterPath + urlString) {
            movieImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), context: nil)
        } else {
            movieImage.image = UIImage(named: "placeholder")
        }
    }
    
}
