//
//  HomeViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 23/06/22.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource = self
        }
    }
    

    
    //let dateString = df.string(from: Date())
    var pacientes = [Paciente]()
    let userID = Auth.auth().currentUser!.uid
    var dateOfDay = ""
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: Date())
        dateLabel.text = dateString
        if NetworkMonitor.shared.isConnected{
            pacientes.removeAll()
            getData()
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        loadUserData()
        //print("ES LA FECHAAAAA DE HOY \(dateOfDay)")
        
        //print("EL USUARIO TIENE UN ID: \(userID)")
        

        // Do any additional setup after loading the view.
    }
    
    
    func loadUserData(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).child("firstName").observeSingleEvent(of: .value) { (snapshot) in
            guard let firstName = snapshot.value as? String else {return}
            self.nameUser?.text = "¡Hola, \(firstName)!"

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "micelda", for: indexPath) as! CustomTableViewCellHome
        let paciente = pacientes[indexPath.row]
        cell.tagLabel?.text = paciente.sTag
        cell.fechaLabel?.text = paciente.sFecha
        cell.nombreLabel?.text = paciente.sNombre
        cell.asuntoTextview?.text = paciente.sAsunto
        cell.timeLabel?.text = paciente.sTime
        cell.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor.valerianaColor.baseLight?.cgColor
        cell.layer.borderWidth = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.= storperformSegue(withIdentifier: "detallePaciente", sender: self)
        let vc = storyboard?.instantiateViewController(withIdentifier: "detallePaciente") as? DetailPacienteViewController
        let pacientes = pacientes[indexPath.row]
        vc?.name = pacientes.sNombre
        vc?.tag = pacientes.sTag
        vc?.asunto = pacientes.sAsunto
        vc?.descripcion = pacientes.sDescripcion
        vc?.indicaciones = pacientes.sIndicaciones
        vc?.prescripcion = pacientes.sPrescripcion
        vc?.numeroCelular = pacientes.sPhone
        vc?.keyPaciente = pacientes.sKey
        vc?.fecha = pacientes.sFecha
        vc?.urlImage = pacientes.sImage
        vc?.time = pacientes.sTime
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

    func getData(){
        let ref = Database.database().reference()
        //let keyValue = ref.child("pacientes").child(userID).childByAutoId().key
        ref.child("pacientes").child(userID).queryOrdered(byChild: "fecha").queryEqual(toValue: dateLabel.text).observe(.childAdded) { [weak self](snapshot) in
            //print("Lo descargado",snapshot.value!)
            //print(dateString)
            //let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else {return}
            if let nombre = value["nombre"] as? String, let asunto = value["asunto"] as? String, let fecha = value["fecha"] as? String, let tag = value["tag"] as? String, let descripcion = value["descripcion"] as? String, let prescripcion = value["prescripcion"] as? String, let indicaciones = value ["indicaciones"] as? String, let numero = value ["numero"] as? String, let key = snapshot.key as? String, let urlImage = value["image"] as? String, let time = value["time"] as? String {
                let paciente = Paciente(sNombre: nombre, sAsunto: asunto, sFecha: fecha, sTag: tag, sDescripcion: descripcion, sPrescripcion: prescripcion, sIndicaciones: indicaciones, sPhone: numero, sKey: key, sImage: urlImage, sTime: time)
                /*self?.pacientes.append(paciente)
                if let row = self?.pacientes.count{
                    let indexPath = IndexPath(row: row-1, section: 0)
                    self?.table.insertRows(at: [indexPath], with: .automatic)
                }*/
                self?.pacientes.append(paciente)
                self?.table?.reloadData()
            }
        }
    }
    

}

/*extension DateFormatter{
    static let dateFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .none
        return df
    }()
    static let timeFormat: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .short
        return df
    }()
    
}*/
