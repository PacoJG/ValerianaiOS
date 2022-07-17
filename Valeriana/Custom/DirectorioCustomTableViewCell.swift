//
//  DirectorioCustomTableViewCell.swift
//  Valeriana
//
//  Created by Francisco Jaime on 12/07/22.
//

import UIKit

class DirectorioCustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        callButton.setTitle("", for: .normal)
        let callImage = UIImage(named: "callIconv2.png")
        callButton.setImage(callImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        profileImage.makeRoundCorners(byRadius: 8)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {
    func makeRoundCorners(byRadius rad: CGFloat){
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
    }
}
