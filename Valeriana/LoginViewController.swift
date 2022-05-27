//
//  LoginViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 25/05/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    var ai = UIActivityIndicatorView()
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBAction func btnLoginAction(_ sender: Any) {
        ai.startAnimating()
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "", message: "Ocurrio un error\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                DispatchQueue.main.async {
                    self.ai.stopAnimating()
                    self.present(alert, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    self.ai.stopAnimating()
                    self.performSegue(withIdentifier: "goHome", sender: nil)
                }
            }
        }
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
    }
        
}

