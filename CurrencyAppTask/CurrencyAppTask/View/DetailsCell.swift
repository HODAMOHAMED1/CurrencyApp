//
//  DetailsCell.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet weak var currencyValueText: UILabel!
    var cellViewModel :  DetailsCellViewModel?{
        didSet {
            currencyValueText.text = cellViewModel?.currencyValue
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
