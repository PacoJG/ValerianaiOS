//
//  LoginViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 16/07/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    var ai = UIActivityIndicatorView()
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    var internetStatus = false
    var internetType = ""
    
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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if NetworkMonitor.shared.isConnected{
            if validateForm() {
                login()
            } else {
                setMessage("Error", "¡Capture correctamente sus datos!")
            }
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //FUNCION DE LOGIN
    func login(){
        ai.startAnimating()
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if error != nil{
                DispatchQueue.main.async {
                    self.setMessage("Error de autenticación", "Usuario o password no encontrado")
                }
                self.ai.stopAnimating()
            }else{
                DispatchQueue.main.async {
                    //self.ai.stopAnimating()
                    self.performSegue(withIdentifier: "goHome", sender: nil)
                }
            }
        }
    }
    
    //FUNCIONES PARA VALIDAR SI EL TEXTFIELD DE PASSWORD Y EMAIL ESTAN LLENOS
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
        
    func validatePassword() -> Bool {
        if passwordTextField.text != "" {
            return true
        } else {
            setMessage("Error", "Capture password")
            return false
        }
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
        
    func validateForm() -> Bool {
        if validateEmail() && validatePassword() {
            return true
        } else {
            return false
        }
    }
    
    //FUNCION PARA PRESENTAR UN ALERT
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
