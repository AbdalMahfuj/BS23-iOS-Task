//
//  DetailShowViewController.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

class DetailShowViewController: UIViewController {
    
    @IBOutlet weak var detailImage          : UIImageView!
    @IBOutlet weak var titleLabel           : UILabel!
    @IBOutlet weak var descriptionLabel     : UILabel!
    @IBOutlet weak var popularityLabel      : UILabel!
    @IBOutlet weak var releaseDateLabel     : UILabel!
    @IBOutlet weak var voteAverageLabel     : UILabel!
    
    var result: Movie?
    let posterPath = "https://image.tmdb.org/t/p/original"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI(movie: result!)
    }
    
    class func initVC(result: Movie)->DetailShowViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "DetailShowViewController") as! DetailShowViewController
        vc.result = result
        return vc
    }
    
    
    func setUI(movie: Movie) {
        titleLabel.text = "\(movie.title ?? "N/A")"
        popularityLabel.text = "\(movie.popularity ?? 0.0)"
        releaseDateLabel.text = "\(movie.release_date ?? "N/A")"
        voteAverageLabel.text = "\(movie.vote_average ?? 0.0) (\(movie.vote_count ?? 0))"
        
        if let desc = movie.overview, desc.count > 0 {
            if let attributedString = try? NSAttributedString(data: Data(desc.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                descriptionLabel.text = "\(attributedString.string)"
            }
        }
       
        
        if let urlString = movie.poster_path, let url = URL(string: posterPath + urlString) {
            detailImage.load(url: url)
        } else {
            detailImage.image = UIImage(named: "placeholder")
        }
    }
    
}
