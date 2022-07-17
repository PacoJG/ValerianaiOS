//
//  SignUpViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 22/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fisrtNameTextField: CustomTextField!
    @IBOutlet weak var secondNameTextField: CustomTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    
    var ai = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "baseLight")
        ai.style = .large
        ai.color = .red
        ai.hidesWhenStopped = true
        ai.center = self.view.center
        self.view.addSubview(ai)
        emailTextField.setupLeftImageView(image: UIImage(named: "mail")!)
        passwordTextField.setupLeftImageView(image: UIImage(named: "lock")!)
        fisrtNameTextField.setupLeftImageView(image: UIImage(named: "user")!)
        secondNameTextField.setupLeftImageView(image: UIImage(named: "user")!)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if NetworkMonitor.shared.isConnected{
            if validateForm() {
                signup()
            } else {
                setMessage("Error", "¡Capture correctamente sus datos!")
            }
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
    }
    
    func validateEmail() -> Bool {
        if emailTextField.text != "" {
            if isValidEmailAddress(emailAddressString: emailTextField.text!) {
                return true
            }
            else {
                setMessage("Error", "Correo electrónico no válido")
                return false
            }
        } else {
            return false
        }
    }
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validatePassword() -> Bool {
        if passwordTextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture password")
            return false
        }
    }
    
    func validateUserName() -> Bool {
        if fisrtNameTextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture nombre")
            return false
        }
    }
    
    func validateUserSecondName() -> Bool {
        if secondNameTextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture nombre")
            return false
        }
    }
    
    func validateForm() -> Bool {
        if validateEmail() && validatePassword() && validateUserName() && validateUserSecondName() {
            return true
        } else {
            return false
        }
    }
    
    func signup(){
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.setMessage("Error de autenticación", "Usuario o password no encontrado")
                }
            }
            else{
                //el usuario se creo correctamente, agregar el nombre y apellido
                guard let uid = result?.user.uid else { return }
                let values = ["email":self.emailTextField.text, "firstName":self.fisrtNameTextField.text, "secondName":self.secondNameTextField.text]
                Database.database().reference().child("users").child(uid).updateChildValues(values, withCompletionBlock:  { (error, ref) in
                    if let error = error {
                        print("Error al crear el usuario", error.localizedDescription)
                        return
                    }
                    
                    print("Usuario correctamente agregado")
                })
                //self.transitionToHome()
                DispatchQueue.main.async {
                    //self.ai.stopAnimating()
                    self.performSegue(withIdentifier: "goHome2", sender: nil)
                }
                
            }
        }
    }
    
}
