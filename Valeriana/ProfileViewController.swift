//
//  ProfileViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 16/07/22.
//

import UIKit
import FirebaseAuth
import MultilineTextField
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlImageProfileLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var aboutMe: MultilineTextField!
    @IBOutlet weak var categoryPicker: UITextField!
    let optionsTag = ["Médico", "Dentista", "Nutriólogo", "Psicólogo"]
    var pickerTag = UIPickerView()
    let userID = Auth.auth().currentUser!.uid
    private let storage = Storage.storage().reference()
    
    @IBOutlet weak var direccionTextView: MultilineTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        getData()
        logoutBtn.setTitle("", for: .normal)
        let logoutImage = UIImage(named: "logoutIcon.png")
        logoutBtn.setImage(logoutImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        categoryPicker.inputView = pickerTag
        pickerTag.dataSource = self
        pickerTag.delegate = self
        pickerTag.tag = 1
        aboutMe.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        aboutMe.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        aboutMe.layer.borderWidth = 1.0
        aboutMe.layer.cornerRadius = 6
        aboutMe.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        aboutMe.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        direccionTextView.contentInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        direccionTextView.placeholderColor = UIColor(red: 0.51, green: 0.77, blue: 0.75, alpha: 1.00)
        direccionTextView.layer.borderWidth = 1.0
        direccionTextView.layer.cornerRadius = 6
        direccionTextView.layer.borderColor = UIColor.valerianaColor.gray?.cgColor
        direccionTextView.layer.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00).cgColor
        profileImage.makeRoundCorners(byRadius: 8)
        
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
    @IBAction func guardarBtnAction(_ sender: Any) {
        if NetworkMonitor.shared.isConnected{
            let values = ["aboutMe":aboutMe.text!, "direccion":direccionTextView.text!, "tag":categoryPicker.text!, "image":urlImageProfileLabel.text!]
            Database.database().reference().child("perfil").child(userID).updateChildValues(values, withCompletionBlock:  { (error, ref) in
                if let error = error {
                    print("Error al actualizar perfil", error.localizedDescription)
                    return
                }
                
                self.setMessage("", "Perfil actualizado con éxito")
            })
            getData()
        }else{
            self.setMessage("", "Error al actualizar el perfil")
        }
    }
    
    @IBAction func tapToChangeProfile(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            //Obtenemos una referencia al SceneDelegate:
            //Podría haber mas de una escena en IpAd OS o en MacOS
            let escena = UIApplication.shared.connectedScenes.first
            print("sesión cerrada")
            let sd = escena?.delegate as! SceneDelegate
            sd.cambiarVistaA("")
        }
        catch {
            print(error.localizedDescription)
        }
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
            categoryPicker.text = optionsTag[row]
            categoryPicker.resignFirstResponder()
        default:
            return
        }
    }
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadUserData(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String:Any] else {return}
            let firstName = value["firstName"] as? String
            let secondName = value["secondName"] as? String
            self.nameLabel?.text = firstName! + " " + secondName!

        }
        
    }
    
    func getData(){
        let ref = Database.database().reference()
        //let keyValue = ref.child("pacientes").child(userID).childByAutoId().key
        ref.child("perfil").child(userID).observe(.childAdded) { [weak self](snapshot) in
            //print("Lo descargado",snapshot.value!)
            //print(dateString)
            //let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else {return}
            self?.aboutMe.text = value["aboutMe"] as? String
            self?.direccionTextView.text = value ["direccion"] as? String
            self?.categoryPicker.text = value["tag"] as? String
            self?.urlImageProfileLabel.text = value["image"] as? String
        }
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
        
        storage.child("images/\(self.nameLabel.text!)file.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                print("error al subir la imagen")
                return
            }
            
            self.storage.child("images/\(self.nameLabel.text!)file.png").downloadURL(completion: {url, error in
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
