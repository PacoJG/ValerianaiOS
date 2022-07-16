//
//  CustomTableViewCellHome.swift
//  Valeriana
//
//  Created by Francisco Jaime on 08/07/22.
//

import UIKit

class CustomTableViewCellHome: UITableViewCell {
    
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var asuntoTextview: UITextView!
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets(top: 8,left: 0,bottom: 8,right: 0)
        asuntoTextview.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        tagLabel.layer.masksToBounds = true
        tagLabel.layer.cornerRadius = 12
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
