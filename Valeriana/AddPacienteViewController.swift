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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    //@IBOutlet weak var tapToChangeProfile: UIButton!
    @IBOutlet weak var urlImageProfileLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    let userID = Auth.auth().currentUser!.uid
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var tagTextField: UITextField!
    
    let df = DateFormatter()
    let df2 = DateFormatter()
    let optionsTag = ["consulta", "extracción", "implantes", "nutricion", "psicología"]
    var pickerTag = UIPickerView()
    //var imagePicker:UIImagePickerController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("", for: .normal)
        let backImage = UIImage(named: "backIcon.png")
        backButton.setImage(backImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        tagTextField.inputView = pickerTag
        pickerTag.dataSource = self
        pickerTag.delegate = self
        pickerTag.tag = 1
        //DATE PICKER
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.semanticContentAttribute = .forceRightToLeft
        datePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft
        df.dateFormat  = "MMM d, yyyy"
        dateLabel.text = df.string(from: datePicker.date)
        //TIME PICKER
        timePicker.datePickerMode = .time
        timePicker.semanticContentAttribute = .forceLeftToRight
        timePicker.preferredDatePickerStyle = .compact
        timePicker.subviews.first?.semanticContentAttribute = .forceRightToLeft
        df2.dateFormat = "HH:mm"
        timeLabel.text = df2.string(from: timePicker.date)
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
        profileImage.makeRoundCorners(byRadius: 8)
        
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
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    @IBAction func elegirTime(_ sender: Any) {
        timeLabel.text = df2.string(from: timePicker.date)
        
    }
    
    @IBAction func guardarPaciente(_ sender: Any) {
        
        if NetworkMonitor.shared.isConnected{
            view.endEditing(true)
            if validateForm(){
                let values = ["nombre":nombretextField.text!, "fecha":dateLabel.text!, "tag":tagTextField.text!, "asunto":String(asuntoTextView.text!), "descripcion":descripcionTextView.text!,"prescripcion":prescripcionTextView.text!, "indicaciones":indicacionesTextView.text!, "numero":phoneNumberTextView.text!, "image":urlImageProfileLabel.text!, "time":timeLabel.text!]
                Database.database().reference().child("pacientes").child(userID).childByAutoId().updateChildValues(values, withCompletionBlock:  { (error, ref) in
                    if let error = error {
                        print("Error al crear al paciente", error.localizedDescription)
                        return
                    }
                    
                    self.setMessage("", "Paciente agregado con exito")
                })
            }else{
                self.setMessage("", "Error al crear al usuario. Asegurese que los campos obligatorios esten llenos")
            }
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        /*let db =  Firestore.firestore()
        db.collection("pacientes").document(nombretextField.text!).setData(["fecha":dateLabel.text!, "tag":tagTextField.text!, "asunto":asuntoTextView.text!, "descripcion":descripcionTextView.text!, "indicaciones":indicacionesTextView.text!, "numero":phoneNumberTextView.text!, "image":urlImageProfileLabel.text!]) { (error) in
            
            if error != nil{
                self.showError("Error saving paciente data")
            }
        }*/
        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return phoneNumberTextView.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateName() -> Bool {
        if nombretextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture el nombre del paciente")
            return false
        }
    }
    
    func validateAsunto() -> Bool {
        if asuntoTextView.text != "" {
            return true
        } else {
            setMessage("Error", "Capture el asunto del paciente")
            return false
        }
    }
    
    func validateFecha() -> Bool {
        if dateLabel.text != "" {
            return true
        } else {
            setMessage("Error", "Capture el la fecha de la consulta")
            return false
        }
    }
    
    func validateTag() -> Bool {
        if tagTextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture el tag de la consulta")
            return false
        }
    }
    
    func validateForm() -> Bool {
        if validateName() && validateAsunto() && validateFecha() && validateTag() {
            return true
        } else {
            return false
        }
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
