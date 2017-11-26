//
//  ViewController.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 5/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

protocol DescubreFilterVC {
    func parseFilter(filter: [String:Any])
}
class DescubreVC: UIViewController, GuardarFiltrarDelegate{
 
    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var actualView: UIView!
    weak var currentViewController: UIViewController?
    var delegate: DescubreFilterVC?
    
    
    var filtroSeleccionado : [String:Any] = [
        "mapa": false,
        "desdelat": 0.0,
        "desdelon": 0.0,
        "hastakm": 1,
        "ordenarpor": 1,
        "filtrarpor": 1
    ]
    
    lazy var sitiosVC: UIViewController? = {
        let sitiosVC = self.storyboard?.instantiateViewController(withIdentifier: "VisitaVC")
        return sitiosVC
    }()
    lazy var eventosVC : UIViewController? = {
        let eventosVC = self.storyboard?.instantiateViewController(withIdentifier: "EventosVC")
        return eventosVC
    }()
    lazy var ofertasVC : UIViewController? = {
        let ofertasVC = self.storyboard?.instantiateViewController(withIdentifier: "OfertasVC")
        return ofertasVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.selector.selectedSegmentIndex = 0
        self.updateView(forSegment: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    func guardarFiltrar(data: [String:Any]) {
        filtroSeleccionado = data
        self.delegate?.parseFilter(filter: filtroSeleccionado)
    }
    
    func updateView(forSegment index: Int){
        if let vc = viewControllerForSelectedSegmentIndex(index) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.actualView.bounds
            self.actualView.addSubview(vc.view)
            self.currentViewController = vc
            self.delegate = vc as? DescubreFilterVC
            
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 0 :
            vc = sitiosVC
        case 1 :
            vc = eventosVC
        default:
            vc = ofertasVC
        }
        return vc
    }
    
    @IBAction func changeTab(_ sender: Any) {
        self.currentViewController?.view.removeFromSuperview()
        self.currentViewController?.removeFromParentViewController()
        self.updateView(forSegment: self.selector.selectedSegmentIndex)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarFiltrarVC"{
            let FiltrarVC : FiltrarVC = segue.destination as! FiltrarVC
            FiltrarVC.delegate = self
            FiltrarVC.filtroSeleccionado = filtroSeleccionado
        }
        
    }
    
}

