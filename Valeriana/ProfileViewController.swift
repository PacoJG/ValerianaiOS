//
//  ProfileViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 16/07/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logoutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        logoutBtn.setTitle("", for: .normal)
        let logoutImage = UIImage(named: "logoutIcon.png")
        logoutBtn.setImage(logoutImage?.withRenderingMode(.alwaysOriginal), for: .normal)

        // Do any additional setup after loading the view.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
