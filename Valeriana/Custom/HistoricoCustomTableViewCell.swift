//
//  HistoricoCustomTableViewCell.swift
//  Valeriana
//
//  Created by Francisco Jaime on 12/07/22.
//

import UIKit

class HistoricoCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var asuntoTextView: UITextView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        asuntoTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
