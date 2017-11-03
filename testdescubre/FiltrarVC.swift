//
//  FiltrarVC.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 18/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import CoreLocation


protocol GuardarFiltrarDelegate {
    func guardarFiltrar(data: [String:Any])
    
}

class FiltrarVC: UIViewController, CLLocationManagerDelegate, ConfirmarElegirCiudadDelegate {
    
    
//    Obtener locacion
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    var delegate: GuardarFiltrarDelegate? = nil
    
    var filtroElegido : Int! = nil
    
    var filtroSeleccionado : [String:Any] = [
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]
    
    
    @IBOutlet weak var recomendadoSw: UISwitch!
    @IBOutlet weak var cercanoSw: UISwitch!
    @IBOutlet weak var precioSw: UISwitch!
    @IBOutlet weak var popularSw: UISwitch!
    
    @IBOutlet weak var comerSw: UISwitch!
    @IBOutlet weak var verSw: UISwitch!
    @IBOutlet weak var dormirSw: UISwitch!
    @IBOutlet weak var serviciosSw: UISwitch!
    
    @IBOutlet weak var hastaStepper: UIStepper!
    
    @IBOutlet weak var textoHastaLbl: UILabel!
    
    @IBOutlet weak var textoUbicacionLbl: UIButton!
    
    // Funciones para hacer que los demas botones se vuelvan nulos. Primer grupo de Switches
    
    func seleccionarRecomendadoSW(){
        recomendadoSw.setOn(true, animated:true)
        cercanoSw.setOn(false, animated: true)
        precioSw.setOn(false, animated: true)
        popularSw.setOn(false, animated: true)
    }
    
    func selecccionarCercanoSw(){
        recomendadoSw.setOn(false, animated:true)
        cercanoSw.setOn(true, animated: true)
        precioSw.setOn(false, animated: true)
        popularSw.setOn(false, animated: true)
    }
    func selecccionarPrecioSw(){
        recomendadoSw.setOn(false, animated:true)
        cercanoSw.setOn(false, animated: true)
        precioSw.setOn(true, animated: true)
        popularSw.setOn(false, animated: true)
        
    }
    func selecccionarPopularSw(){
        recomendadoSw.setOn(false, animated:true)
        cercanoSw.setOn(false, animated: true)
        precioSw.setOn(false, animated: true)
        popularSw.setOn(true, animated: true)
        
    }
    
    // Funciones para hacer que los demas botones se vuelvan nulos. Segundo grupo de Switches
    
    func seleccionarComerSw(){
        comerSw.setOn(true, animated: true)
        verSw.setOn(false, animated: true)
        dormirSw.setOn(false, animated: true)
        serviciosSw.setOn(false, animated: true)
    }
    
    func seleccionarVerSw(){
        comerSw.setOn(false, animated: true)
        verSw.setOn(true, animated: true)
        dormirSw.setOn(false, animated: true)
        serviciosSw.setOn(false, animated: true)
    }
    
    func seleccionarDormirSw(){
        comerSw.setOn(false, animated: true)
        verSw.setOn(false, animated: true)
        dormirSw.setOn(true, animated: true)
        serviciosSw.setOn(false, animated: true)
    }
    
    func seleccionarServiciosSw(){
        comerSw.setOn(false, animated: true)
        verSw.setOn(false, animated: true)
        dormirSw.setOn(false, animated: true)
        serviciosSw.setOn(true, animated: true)
    }
    
    
    
    @IBAction func hastaStepperCambio(_ sender: UIStepper) {
        filtroSeleccionado["hastakm"] = Int(sender.value)
        print ("El valor del stepper es \(Int(sender.value))")
        textoHastaLbl.text = "\(Int(sender.value)) Km"
        
    }

    
//    @IBAction func ubicacionActualBtn(_ sender: UIButton) {
//        performSegue(withIdentifier: "mostrarElegirMapaVC", sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mostrarElegirMapaVC"{
            let ElegirMapaVC : ElegirMapaVC = segue.destination as! ElegirMapaVC
            ElegirMapaVC.delegate = self
            ElegirMapaVC.filtroSeleccionado = filtroSeleccionado
        
        }
        
    }
    
    func confirmarElegirCiudad(data: [String:Any]) {
        filtroSeleccionado = data
    }
    
    
    
    
  // Primer grupo 
    
    @IBAction func recomendadoSw(_ sender: UISwitch) {
        if sender.isOn{
            seleccionarRecomendadoSW()
            filtroSeleccionado["ordenarpor"] = 1
        }
        
    }
    @IBAction func cercanoSw(_ sender: UISwitch) {
        if sender.isOn{
            selecccionarCercanoSw()
            filtroSeleccionado["ordenarpor"] = 2
        }
    }
    @IBAction func precioSw(_ sender: UISwitch) {
        if sender.isOn{
            selecccionarPrecioSw()
            filtroSeleccionado["ordenarpor"] = 3
        }
    }
    @IBAction func popularSw(_ sender: UISwitch) {
        if sender.isOn{
            selecccionarPopularSw()
            filtroSeleccionado["ordenarpor"] = 4
        }
    }    

    //Segundo grupo
    
    @IBAction func comerSw(_ sender: UISwitch){
        if sender.isOn{
            seleccionarComerSw()
            filtroSeleccionado["filtrarpor"] = 1
        }
    }
    @IBAction func verSw(_ sender: UISwitch){
        if sender.isOn{
            seleccionarVerSw()
            filtroSeleccionado["filtrarpor"] = 2
            
        }
    }
    @IBAction func dormirSw(_ sender: UISwitch){
        if sender.isOn{
            seleccionarDormirSw()
            filtroSeleccionado["filtrarpor"] = 3
        }
    }
    @IBAction func serviciosSw(_ sender: UISwitch){
        if sender.isOn{
            seleccionarServiciosSw()
            filtroSeleccionado["filtrarpor"] = 4
        }
    }
    
    
    @IBAction func guardarBtn(_ sender: UIBarButtonItem) {

        if delegate != nil {
            var data : Int = 0
            
            if recomendadoSw.isOn {data = 1}
            if cercanoSw.isOn {data = 2}
            if precioSw.isOn {data = 3}
            if popularSw.isOn {data = 4}
            
            
            delegate?.guardarFiltrar(data: filtroSeleccionado)
            print (data)
            
            print (filtroSeleccionado)
            
            self.navigationController?.popViewController(animated: true)
        }
       
      }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        

//        Configurar steppers para que tengan un minimo y un maximo

        hastaStepper.wraps = false
        hastaStepper.autorepeat = true
        hastaStepper.maximumValue = 25
        hastaStepper.value = 0

        
        
//        Mostrar la cantidad de km que venia llevando
        
        let hastakm = filtroSeleccionado["hastakm"] as! Int
        textoHastaLbl.text = "\(hastakm) Km"

        
//        Configurar los switches basado en el valor que tengan
        
        
//        if filtroSeleccionado["hastakm"] as! Int > 0 {textoHastaLbl.text = "\(String(describing: filtroSeleccionado["hastakm"])) Km"}
        
        if filtroSeleccionado["ordenarpor"] as! Int == 1 {seleccionarRecomendadoSW()}
        if filtroSeleccionado["ordenarpor"] as! Int == 2 {selecccionarCercanoSw()}
        if filtroSeleccionado["ordenarpor"] as! Int == 3 {selecccionarPrecioSw()}
        if filtroSeleccionado["ordenarpor"] as! Int == 4 {selecccionarPopularSw()}
        
        if filtroSeleccionado["filtrarpor"] as! Int == 1 {seleccionarComerSw()}
        if filtroSeleccionado["filtrarpor"] as! Int == 2 {seleccionarVerSw()}
        if filtroSeleccionado["filtrarpor"] as! Int == 3 {seleccionarDormirSw()}
        if filtroSeleccionado["filtrarpor"] as! Int == 4 {seleccionarServiciosSw()}
        
        
//      Que te muestre la ubicacion actual cuando inicias
        
//        Cambiar texto de seleccionar ubicacion al que venia llevando
        
        let desdelat = filtroSeleccionado["desdelat"] as! Double
        let desdelon = filtroSeleccionado["desdelon"] as! Double
        
        if desdelat == 0.0 && desdelon == 0.0 {

            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.requestWhenInUseAuthorization()
            locManager.startUpdatingLocation()
            
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                
                currentLocation = locManager.location
                
                filtroSeleccionado["desdelat"] = currentLocation.coordinate.latitude
//                desdelat = currentLocation.coordinate.latitude
                
                filtroSeleccionado["desdelon"] = currentLocation.coordinate.longitude
//                desdelon = currentLocation.coordinate.longitude
                
//                let textosobreboton = "\(desdelat), \(desdelon)"
                textoUbicacionLbl.setTitle("Ubicación actual", for: .normal)
                
            }
            
            
        }else {
            textoUbicacionLbl.setTitle("Ubicación cambiada", for: .normal)
        }
    
        
        
        
        
        
        
        
        
        
        
    }
    
 
}