//
//  CalendarViewController.swift
//  Valeriana
//
//  Created by Francisco Jaime on 06/07/22.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
                              UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedDate = Date()
    var totalSquares = [Date]()
    var pacientes = [Paciente]()
    let date = Date()
    let df = DateFormatter()
    var fecha = Date()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dateString)
        addButton.setTitle("", for: .normal)
        let addImage = UIImage(named: "addIcon.png")
        addButton.setImage(addImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        setCellsView()
        setWeekView()
        print(fecha)

        // Do any additional setup after loading the view.
    }
    
    func setCellsView()
    {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setWeekView()
    {
        totalSquares.removeAll()
        
        var current = CalendarHelper().sundayForDate(date: selectedDate)
        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
        
        while (current < nextSunday)
        {
            totalSquares.append(current)
            current = CalendarHelper().addDays(date: current, days: 1)
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
        pacientes.removeAll()
        
        if(date == selectedDate)
        {
            cell.backgroundColor = UIColor.systemGreen
            fecha = date
            pacientes.removeAll()
            getData()
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        selectedDate = totalSquares[indexPath.item]
        pacientes.removeAll()
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func previousWeek(_ sender: Any)
    {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
        setWeekView()
    }
    
    @IBAction func nextWeek(_ sender: Any)
    {
        selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
        setWeekView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return pacientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCalendar", for: indexPath) as! CalendarCustomTableViewCell
        let paciente = pacientes[indexPath.row]
        cell.nameLabel?.text = paciente.sNombre
        cell.tagLabel?.text = paciente.sTag
        cell.dateLabel?.text = paciente.sFecha
        cell.asuntoTextView.text = paciente.sAsunto
        cell.layer.borderColor = UIColor.valerianaColor.baseLight?.cgColor
        cell.layer.borderWidth = 8
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func getData(){
        df.dateFormat = "MMM d, yyyy"
        let dateString = df.string(from: fecha)
        let ref = Database.database().reference()
        ref.child("pacientes").queryOrdered(byChild: "fecha").queryEqual(toValue: dateString ).observe(DataEventType.childAdded) { [weak self](snapshot) in
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
                self?.pacientes.append(paciente)
                self?.tableView?.reloadData()
            }
        }
    }
    
    
    /*@IBAction func cerrarSesion(_ sender: Any) {
        
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
    }*/

}
