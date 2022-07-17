//
//  DirectorioViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 12/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
    let userID = Auth.auth().currentUser!.uid
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.setImage(UIImage(named: "searchIcon"), for: .search, state: .normal)
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 10.0, vertical: 0.0)
        /*.backgroundColor = UIColor.clear
        searchBar.tintColor = UIColor.clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.isTranslucent = true*/
        //searchBar.customize()
        self.searchBar.searchTextField.borderStyle = .none
        self.searchBar.searchTextField.layer.cornerRadius = 6
        self.searchBar.searchTextField.layer.borderWidth = 1
        self.searchBar.searchTextField.textColor = UIColor.valerianaColor.fontBase
        //self.searchBar.searchTextField.font = UIFont(name: "OpenSans", size: 12)
        self.searchBar.searchTextField.layer.borderColor = UIColor.valerianaColor.fontBase?.cgColor
        self.searchBar.searchTextField.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetworkMonitor.shared.isConnected{
            getData()
            //let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
            //view.addGestureRecognizer(tap)
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
        searchBar.delegate = self
        //let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        //view.addGestureRecognizer(tap)

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
        cell.callButton.tag = indexPath.row
        cell.callButton.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        let backgroundvIEW = UIView()
        backgroundvIEW.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundvIEW
        return cell
    }
    
    @objc func btnAction(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let pacienteSelected = pacientesDir[indexPath.row]
        callNumber(phoneNumber: pacienteSelected.sPhone)
    }
    
    private func callNumber(phoneNumber:String) {
      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("APRIETO EL BOTOOOOON")
        let vc = storyboard?.instantiateViewController(withIdentifier: "historicoPaciente") as? HistoricoViewController
        let pacientes = pacientesDir[indexPath.row]
        vc?.name = pacientes.sNombre
        vc?.urlImage = pacientes.sImage
        vc?.phoneNumber = pacientes.sPhone
        self.navigationController?.pushViewController(vc!, animated: true)
        //self.present(vc!, animated: true, completion: nil)
    }
    
    func getData(){
        //df.dateFormat = "MMM d, yyyy"
        //let dateString = df.string(from: date)
        let ref = Database.database().reference()
        ref.child("pacientes").child(userID).observe(DataEventType.childAdded) { [weak self](snapshot) in
            //print("Lo descargado",snapshot.value!)
            //print(dateString)
            //let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else {return}
            if let nombre = value["nombre"] as? String, let asunto = value["asunto"] as? String, let fecha = value["fecha"] as? String, let tag = value["tag"] as? String, let descripcion = value["descripcion"] as? String, let prescripcion = value["prescripcion"] as? String, let indicaciones = value ["indicaciones"] as? String, let numero = value ["numero"] as? String, let key = snapshot.key as? String, let urlImage = value["image"] as? String, let time = value["time"] as? String {
                let paciente = Paciente(sNombre: nombre, sAsunto: asunto, sFecha: fecha, sTag: tag, sDescripcion: descripcion, sPrescripcion: prescripcion, sIndicaciones: indicaciones, sPhone: numero, sKey: key, sImage: urlImage, sTime: time)
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

