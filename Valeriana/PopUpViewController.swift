//
//  PopUpViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 15/07/22.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var indicacionesTextView: UITextView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var prescripcionTextView: UITextView!
    @IBOutlet weak var asuntoTextView: UITextView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tag = ""
    var asunto = ""
    var prescripcion = ""
    var indicaciones = ""
    var fecha = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exitBtn.setTitle("", for: .normal)
        let exitImage = UIImage(named: "exitIcon.png")
        exitBtn.setImage(exitImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dateLabel.text = fecha
        prescripcionTextView.text = prescripcion
        asuntoTextView.text = asunto
        tagLabel.text = tag
        indicacionesTextView.text = indicaciones
        timeLabel.text = time
        
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
