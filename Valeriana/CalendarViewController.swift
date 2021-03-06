//
//  CalendarViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 14/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedDate = Date()
    var totalSquares = [Date]()
    let date = Date()
    let df = DateFormatter()
    var fecha = Date()
    var pacientes = [Paciente]()
    
    let userID = Auth.auth().currentUser!.uid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: Date())
        dateLabel.text = dateString
        if NetworkMonitor.shared.isConnected{
            table.reloadData()
        }else{
            let alert = UIAlertController(title: "No hay internet", message: "Esta app requiere wifi/internet para funcionar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Salir", style: UIAlertAction.Style.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //pacientes.removeAll()
        
        //getData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        collectionView.delegate = self
        collectionView.dataSource =  self
        addButton.setTitle("", for: .normal)
        let addImage = UIImage(named: "addIcon.png")
        addButton.setImage(addImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        setCellsView()
        setWeekView()

        // Do any additional setup after loading the view.
    }
    
    func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 9
        let height = (collectionView.frame.size.height - 2)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setWeekView() {
        totalSquares.removeAll()
            
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
            
        while (current < nextSunday){
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
            
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        //table.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
            
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
            
        if(date == selectedDate) {
            cell.backgroundColor = UIColor.valerianaColor.greenLight
            fecha = date
            //pacientes.removeAll()
            getData()
            //table.reloadData()
        }
        else {
            cell.backgroundColor = UIColor.valerianaColor.baseLight
        }
        return cell
    }
        
    @IBAction func previusWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        pacientes.removeAll()
        //getData()
        table.reloadData()
        setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: Any) {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        pacientes.removeAll()
        //getData()
        table.reloadData()
        setWeekView()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = totalSquares[indexPath.item]
        pacientes.removeAll()
        collectionView.reloadData()
        table.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "miceldaCalendar", for: indexPath) as! CalendarCustomTableViewCell
        //cell.textLabel?.text = "Hellow world"
        let paciente = pacientes[indexPath.row]
        cell.nameLabel?.text = paciente.sNombre
        cell.tagLabel?.text = paciente.sTag
        cell.dateLabel?.text = paciente.sFecha
        cell.timeLabel?.text = paciente.sTime
        cell.asuntoTextView.text = String(paciente.sAsunto)
        cell.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor.valerianaColor.baseLight?.cgColor
        cell.layer.borderWidth = 8
        return cell
    }

    func getData(){
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: fecha)
        let ref = Database.database().reference()
        ref.child("pacientes").child(userID).queryOrdered(byChild: "fecha").queryEqual(toValue: dateString).observe(DataEventType.childAdded) { [weak self](snapshot) in
            //print("Lo descargado",snapshot.value!)
            //print(dateString)
            //let key = snapshot.key
            guard let value = snapshot.value as? [String:Any] else {return}
            if let nombre = value["nombre"] as? String, let asunto = value["asunto"] as? String, let fecha = value["fecha"] as? String, let tag = value["tag"] as? String, let descripcion = value["descripcion"] as? String, let prescripcion = value["prescripcion"] as? String, let indicaciones = value ["indicaciones"] as? String, let numero = value ["numero"] as? String, let key = snapshot.key as? String, let urlImage = value["image"] as? String, let time = value["time"] as? String {
                let paciente = Paciente(sNombre: nombre, sAsunto: asunto, sFecha: fecha, sTag: tag, sDescripcion: descripcion, sPrescripcion: prescripcion, sIndicaciones: indicaciones, sPhone: numero, sKey: key, sImage: urlImage, sTime: time)
                self?.pacientes.removeAll()
                self?.pacientes.append(paciente)
                self?.table?.reloadData()
            }
        }
    }
}
