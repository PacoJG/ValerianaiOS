//
//  CalendarViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 06/07/22.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.setTitle("", for: .normal)
        let addImage = UIImage(named: "addIcon.png")
        addButton.setImage(addImage?.withRenderingMode(.alwaysOriginal), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cerrarSesion(_ sender: Any) {
        
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

}
