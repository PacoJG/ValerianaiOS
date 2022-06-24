//
//  SignUpViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 22/06/22.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fisrtNameTextField: CustomTextField!
    @IBOutlet weak var secondNameTextField: CustomTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        emailTextField.setupLeftImageView(image: UIImage(named: "mail")!)
        passwordTextField.setupLeftImageView(image: UIImage(named: "lock")!)
        fisrtNameTextField.setupLeftImageView(image: UIImage(named: "user")!)
        secondNameTextField.setupLeftImageView(image: UIImage(named: "user")!)

        // Do any additional setup after loading the view.
    }
    
    func validateFields() -> String? {
        
        if fisrtNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || secondNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //validar la seguridad del password
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Porfavor ingrese una contraseña con 8 caracteres, que incluya un caracter especial y un número"
        }
        
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validar los campos
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else{
            
            let fisrtName = fisrtNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = secondNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                
                if error != nil {
                    //hubo un error al crear el usuario
                    self.showError("Error al crear el usuario")
                }
                else{
                    //el usuario se creo correctamente, agregar el nombre y apellido
                    let db =  Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":fisrtName, "secondName": secondName, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    //self.transitionToHome()
                    DispatchQueue.main.async {
                        //self.ai.stopAnimating()
                        self.performSegue(withIdentifier: "goHome2", sender: nil)
                    }
                    
                }
            }
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
