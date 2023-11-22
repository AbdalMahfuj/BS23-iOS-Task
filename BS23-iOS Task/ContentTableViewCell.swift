//
//  ContentTableViewCell.swift
//  BS23-iOS Task
//
//  Created by MAHFUJ on 23/11/23.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var tvshowImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tvshowImage.layer.cornerRadius = 8.0
        tvshowImage.clipsToBounds = true
    }
    
  /*  func setUI(tvshow: TVShow) {
        nameLabel.text = tvshow.details?.name
        scoreLabel.text = "Score: " + String(format: "%0.2f", tvshow.score ?? 0.0)
        runtimeLabel.text = "Runtime: \(tvshow.details?.runtime ?? 0.0) m"
        if let urlString = tvshow.imageURL, let url = URL(string: urlString) {
            tvshowImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), context: nil)
        } else {
            tvshowImage.image = UIImage(named: "placeholder")
        }
    } */
    
}
