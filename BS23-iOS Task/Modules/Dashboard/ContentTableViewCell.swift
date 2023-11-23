//
//  ContentTableViewCell.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit
import SDWebImage

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView        : UIView!
    @IBOutlet weak var titleLabel           : UILabel!
    @IBOutlet weak var popularityLabel      : UILabel!
    @IBOutlet weak var releaseDateLabel     : UILabel!
    @IBOutlet weak var ratingLabel          : UILabel!
    @IBOutlet weak var movieImage           : UIImageView!
    
    static let identifier = "ContentTableViewCell"
    
    let posterPath = "https://image.tmdb.org/t/p/original"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow()
        movieImage.layer.cornerRadius = 8.0
        movieImage.clipsToBounds = true
    }
    
    
    func setUI(movie: MovieModel) {
        titleLabel.text = movie.title
        popularityLabel.text = "Popularity: " + String(format: "%0.2f", movie.popularity ?? 0.0)
        releaseDateLabel.text = "Release Date: \(movie.release_date ?? "N/A")"
        ratingLabel.text = "Rating: " + String(format: "%0.2f", movie.vote_average ?? 0)
//        if let urlString = movie.poster_path, let url = URL(string: posterPath + urlString) {
//            movieImage.load(url: url)
//        } else {
//            movieImage.image = UIImage(named: "placeholder")
//        }
        
       if let urlString = movie.poster_path, let url = URL(string: posterPath + urlString) {
            movieImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), context: nil)
        }
    }
    
}
