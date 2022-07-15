//
//  DirectorioViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 12/07/22.
//

import UIKit
import FirebaseDatabase

class DirectorioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var table: UITableView!{
        didSet{
            table.dataSource = self
        }
    }
    
    var pacientesDir = [Paciente]()
    var filterpacientesDir = [Paciente]()
    var tmp: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pacientesDir.removeAll()
        getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table?.delegate = self
        table?.dataSource = self
        searchBar.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacientesDir.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "miceldaDirectorio", for: indexPath) as! DirectorioCustomTableViewCell
        let paciente = pacientesDir[indexPath.row]
        cell.nombreLabel?.text = paciente.sNombre
        cell.profileImage.loadFrom(URLAddress: paciente.sImage)
        cell.layer.borderColor = UIColor.valerianaColor.baseLight?.cgColor
        cell.layer.borderWidth = 8
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "historialPaciente") as? HistoricoViewController
        let pacientes = pacientesDir[indexPath.row]
        vc?.name = pacientes.sNombre
        vc?.urlImage = pacientes.sImage
        vc?.phoneNumber = pacientes.sPhone
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func getData(){
        //df.dateFormat = "MMM d, yyyy"
        //let dateString = df.string(from: date)
        let ref = Database.database().reference()
        ref.child("pacientes").observe(DataEventType.childAdded) { [weak self](snapshot) in
            print("Lo descargado",snapshot.value!)
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
                if ((self?.tmp.contains(paciente.sNombre)) != true) {
                    self?.tmp.append(paciente.sNombre)
                    self?.pacientesDir.append(paciente)
                    self?.filterpacientesDir.append(paciente)
                    self?.table?.reloadData()
                }
                
            }
            //print(self?.tmp)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            pacientesDir = filterpacientesDir
            self.table.reloadData()
        }else{
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text:String){
        pacientesDir = pacientesDir.filter({ (mod) -> Bool in
            return mod.sNombre.lowercased().contains(text.lowercased())
        })
        self.table.reloadData()
    }


}

