//
//  HistoricoViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 12/07/22.
//

import UIKit
import FirebaseDatabase

class HistoricoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource = self
        }
    }
    
    var name = ""
    var urlImage = ""
    var phoneNumber = ""
    let date = Date()
    let df = DateFormatter()
    var pacientes = [Paciente]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pacientes.removeAll()
        getData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
        
        callButton.setTitle("", for: .normal)
        let callImage = UIImage(named: "callIcon.png")
        callButton.setImage(callImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        messageButton.setTitle("", for: .normal)
        let messageImage = UIImage(named: "messageIcon.png")
        messageButton.setImage(messageImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        nameLabel.text = name
        profileImage.loadFrom(URLAddress: urlImage)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func callButton(_ sender: Any) {
        callNumber(phoneNumber: phoneNumber)
    }
    
    @IBAction func messageButton(_ sender: Any) {
    }
    
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "miceldaHistorico", for: indexPath) as! HistoricoCustomTableViewCell
        let paciente = pacientes[indexPath.row]
        cell.fechaLabel?.text = paciente.sFecha
        cell.tagLabel?.text = paciente.sTag
        cell.asuntoTextView?.text = paciente.sAsunto
        cell.layer.borderColor = UIColor.valerianaColor.baseLight?.cgColor
        cell.layer.borderWidth = 8
        return cell
    }
    
    func getData(){
        df.dateFormat = "MMM d, yyyy"
        //let dateString = df.string(from: date)
        let ref = Database.database().reference()
        ref.child("pacientes").queryOrdered(byChild: "nombre").queryEqual(toValue: name).observe(DataEventType.childAdded) { [weak self](snapshot) in
            //print("Lo descargado",snapshot.value!)
            //print(dateString)
            //let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else {return}
            if let nombre = value["nombre"] as? String, let asunto = value["asunto"] as? String, let fecha = value["fecha"] as? String, let tag = value["tag"] as? String, let descripcion = value["descripcion"] as? String, let prescripcion = value["prescripcion"] as? String, let indicaciones = value ["indicaciones"] as? String, let numero = value ["numero"] as? String, let key = snapshot.key as? String, let urlImage = value["image"] as? String {
                let paciente = Paciente(sNombre: nombre, sAsunto: asunto, sFecha: fecha, sTag: tag, sDescripcion: descripcion, sPrescripcion: prescripcion, sIndicaciones: indicaciones, sPhone: numero, sKey: key, sImage: urlImage)
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
