//
//  Paciente.swift
//  Valeriana
//
//  Created by Francisco Jaime on 08/07/22.
//

import UIKit

class Paciente: NSObject {
    
    var sNombre:String
    var sAsunto:String
    var sFecha:String
    var sTag:String
    var sDescripcion:String
    var sPrescripcion:String
    var sIndicaciones:String
    var sPhone:String
    var sKey: String
    var sImage: String
    var sTime: String
    //, sDescripcion: String, sPrescripcion: String, sIndicaciones: String, sPhone: String
    init(sNombre: String, sAsunto: String, sFecha: String, sTag: String, sDescripcion: String, sPrescripcion: String, sIndicaciones: String, sPhone: String, sKey: String, sImage: String, sTime: String){
        self.sNombre = sNombre
        self.sAsunto = sAsunto
        self.sFecha = sFecha
        self.sTag = sTag
        self.sDescripcion = sDescripcion
        self.sPrescripcion = sPrescripcion
        self.sIndicaciones = sIndicaciones
        self.sPhone = sPhone
        self.sKey = sKey
        self.sTime = sTime
        self.sImage = sImage
        
    }

}
