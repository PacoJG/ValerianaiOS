//
//  DetailPacienteViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 10/07/22.
//

import UIKit
import MultilineTextField
import FirebaseDatabase
import FirebaseAuth

class DetailPacienteViewController: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var urlImageLabel: UILabel!
    @IBOutlet weak var asuntoTextView: MultilineTextField!
    @IBOutlet weak var descripcionTextView: MultilineTextField!
    @IBOutlet weak var prescripcionTextView: MultilineTextField!
    @IBOutlet weak var IndicacionesTextView: MultilineTextField!
    @IBOutlet weak var numeroCelulartextView: MultilineTextField!
    
    var name = ""
    var asunto = ""
    var descripcion = ""
    var prescripcion = ""
    var indicaciones = ""
    var numeroCelular = ""
    var tag = ""
    var keyPaciente = ""
    var fecha = ""
    var urlImage = ""
    var time = ""
    
    let userID = Auth.auth().currentUser!.uid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagLabel.layer.masksToBounds = true
        tagLabel.layer.cornerRadius = 12
        
        //print(keyPaciente)
        
        asuntoTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        asuntoTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        asuntoTextView.layer.borderWidth = 1.0
        asuntoTextView.layer.cornerRadius = 6
        asuntoTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        asuntoTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        descripcionTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        descripcionTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        descripcionTextView.layer.borderWidth = 1.0
        descripcionTextView.layer.cornerRadius = 6
        descripcionTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        descripcionTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        prescripcionTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        prescripcionTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        prescripcionTextView.layer.borderWidth = 1.0
        prescripcionTextView.layer.cornerRadius = 6
        prescripcionTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        prescripcionTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        IndicacionesTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        IndicacionesTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        IndicacionesTextView.layer.borderWidth = 1.0
        IndicacionesTextView.layer.cornerRadius = 6
        IndicacionesTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        IndicacionesTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        numeroCelulartextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        numeroCelulartextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        numeroCelulartextView.layer.borderWidth = 1.0
        numeroCelulartextView.layer.cornerRadius = 6
        numeroCelulartextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        numeroCelulartextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        imageProfile.makeRoundCorners(byRadius: 8)
        
        navigationItem.hidesBackButton = true
        
        callButton.setTitle("", for: .normal)
        let callImage = UIImage(named: "callIcon.png")
        callButton.setImage(callImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        messageButton.setTitle("", for: .normal)
        let messageImage = UIImage(named: "messageIcon.png")
        messageButton.setImage(messageImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        backButton.setTitle("", for: .normal)
        let backImage = UIImage(named: "backIcon.png")
        backButton.setImage(backImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        imageProfile.loadFrom(URLAddress: urlImage)
        
        nameLabel.text = name
        asuntoTextView.text = asunto
        descripcionTextView.text = descripcion
        IndicacionesTextView.text = indicaciones
        numeroCelulartextView.text = numeroCelular
        prescripcionTextView.text = prescripcion
        tagLabel.text = tag
        timeLabel.text = time

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func callButton(_ sender: Any) {
        callNumber(phoneNumber: numeroCelular)
    }
    
    @IBAction func EditarData(_ sender: Any) {
        if NetworkMonitor.shared.isConnected{
            view.endEditing(true)
            
            let values = ["nombre":nameLabel.text!, "fecha":fecha, "tag":tagLabel.text!, "asunto":asuntoTextView.text!, "descripcion":descripcionTextView.text!,"prescripcion":prescripcionTextView.text!, "indicaciones":IndicacionesTextView.text!, "numero":numeroCelulartextView.text!, "image":urlImage, "time":timeLabel.text!]
            Database.database().reference().child("pacientes").child(userID).child(keyPaciente).updateChildValues(values, withCompletionBlock:  { [self] (error, ref) in
                if let error = error {
                    let alert = UIAlertController(title: "", message: "Ocurrio un error al editar al paciente\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    present(alert, animated: true)
                    return
                } else{
                    let alert = UIAlertController(title: "", message: "Edición de paciente exitosa", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    present(alert, animated: true)
                }
            })
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
