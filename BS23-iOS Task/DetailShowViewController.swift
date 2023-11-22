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
    @IBOutlet weak var ratingLabel          : UILabel!
    @IBOutlet weak var runtimeLabel         : UILabel!
    @IBOutlet weak var languageLabel        : UILabel!
    
    var result: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  setUI(movie: result!)
    }
    
    class func initVC(result: Movie)->DetailShowViewController {
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(withIdentifier: "DetailShowViewController") as! DetailShowViewController
        vc.result = result
        return vc
    }
    
    
  /*  func setUI(movie: Movie) {
        titleLabel.text = "Title: \(movie.details?.name ?? "N/A")"
        ratingLabel.text = "Rating: \(movie.details?.rating?.average ?? 0.0)"
        runtimeLabel.text = "Runtime: \(movie.details?.runtime ?? 0.0)"
        languageLabel.text = "Language: \(movie.details?.language ?? "N/A")"
        
        if let desc = movie.details?.summary, desc.count > 0 {
            if let attributedString = try? NSAttributedString(data: Data(desc.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                descriptionLabel.text = "Summary: \(attributedString.string)"
            }
        }
       
        
        if let urlString = movie.imageURL, let url = URL(string: urlString) {
            detailImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), context: nil)
        } else {
            detailImage.image = UIImage(named: "placeholder")
        }
    } */
    
}
