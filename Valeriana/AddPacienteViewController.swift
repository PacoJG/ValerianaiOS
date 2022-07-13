//
//  AddPacienteViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 30/06/22.
//

import UIKit
import MultilineTextField
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseStorage
import FirebaseDatabase

class AddPacienteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    //TextView for AddPaciente
    @IBOutlet weak var asuntoTextView: MultilineTextField!
    @IBOutlet weak var descripcionTextView: MultilineTextField!
    @IBOutlet weak var prescripcionTextView: MultilineTextField!
    @IBOutlet weak var indicacionesTextView: MultilineTextField!
    @IBOutlet weak var phoneNumberTextView: MultilineTextField!
    @IBOutlet weak var nombretextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    //@IBOutlet weak var tapToChangeProfile: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var urlImageProfileLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tagTextField: UITextField!
    let df = DateFormatter()
    let optionsTag = ["consulta", "extracción", "implantes"]
    var pickerTag = UIPickerView()
    //var imagePicker:UIImagePickerController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagTextField.inputView = pickerTag
        pickerTag.dataSource = self
        pickerTag.delegate = self
        pickerTag.tag = 1
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.semanticContentAttribute = .forceRightToLeft
        datePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft
        df.dateFormat  = "MMM d, yyyy"
        dateLabel.text = df.string(from: datePicker.date)
        //Data ASUNTO
        asuntoTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        asuntoTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        asuntoTextView.layer.borderWidth = 1.0
        asuntoTextView.layer.cornerRadius = 6
        asuntoTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        asuntoTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        //Data DESCRIPCION
        descripcionTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        descripcionTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        descripcionTextView.layer.borderWidth = 1.0
        descripcionTextView.layer.cornerRadius = 6
        descripcionTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        descripcionTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        //Data PRECRIPCION
        prescripcionTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        prescripcionTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        prescripcionTextView.layer.borderWidth = 1.0
        prescripcionTextView.layer.cornerRadius = 6
        prescripcionTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        prescripcionTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        //Data INDICACIONES
        indicacionesTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        indicacionesTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        indicacionesTextView.layer.borderWidth = 1.0
        indicacionesTextView.layer.cornerRadius = 6
        indicacionesTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        indicacionesTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        //Data PHONE
        phoneNumberTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        phoneNumberTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        phoneNumberTextView.layer.borderWidth = 1.0
        phoneNumberTextView.layer.cornerRadius = 6
        phoneNumberTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        phoneNumberTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        
        self.phoneNumberTextView.delegate = self
        
        //Imagen de paciente
        //tapToChangeProfile.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        guard let urlString = UserDefaults.standard.value(forKey: "url") as? String, let url = URL(string: urlString) else{
            return
        }
        
        urlImageProfileLabel.text = urlString
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.profileImage.image = image
            }
            
        })
        
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToChangeProfile(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func elegirFecha(_ sender: Any) {
        dateLabel.text = df.string(from: datePicker.date)
        
    }
    
    @IBAction func guardarPaciente(_ sender: Any) {
        view.endEditing(true)
        /*let db =  Firestore.firestore()
        db.collection("pacientes").document(nombretextField.text!).setData(["fecha":dateLabel.text!, "tag":tagTextField.text!, "asunto":asuntoTextView.text!, "descripcion":descripcionTextView.text!, "indicaciones":indicacionesTextView.text!, "numero":phoneNumberTextView.text!, "image":urlImageProfileLabel.text!]) { (error) in
            
            if error != nil{
                self.showError("Error saving paciente data")
            }
        }*/
        let values = ["nombre":nombretextField.text!, "fecha":dateLabel.text!, "tag":tagTextField.text!, "asunto":asuntoTextView.text!, "descripcion":descripcionTextView.text!,"prescripcion":prescripcionTextView.text!, "indicaciones":indicacionesTextView.text!, "numero":phoneNumberTextView.text!, "image":urlImageProfileLabel.text!]
        Database.database().reference().child("pacientes").childByAutoId().updateChildValues(values, withCompletionBlock:  { (error, ref) in
            if let error = error {
                print("Error al crear al paciente", error.localizedDescription)
                return
            }
            
            print("Paciente correctamente agregado")
        })
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return optionsTag.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return optionsTag[row]
        default:
            return "Data not found"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            tagTextField.text = optionsTag[row]
            tagTextField.resignFirstResponder()
        default:
            return
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return phoneNumberTextView.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension AddPacienteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else{
            return
        }
        
        storage.child("images/\(self.nombretextField.text!)file.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("error al subir la imagen")
                return
            }
            
            self.storage.child("images/\(self.nombretextField.text!)file.png").downloadURL(completion: {url, error in
                guard let url = url, error == nil else{
                    return
                }
                
                let urlString = url.absoluteString
                DispatchQueue.main.async {
                    self.urlImageProfileLabel.text = urlString
                    self.profileImage.image = image
                }
                
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url")
            })
        })
        
        
    }
}

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
