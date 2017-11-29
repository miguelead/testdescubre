//
//  puntodeinteresCell.swift
//  testdescubre
//
//  Created by Miguel Alvarez on 11/9/17.
//  Copyright © 2017 Miguel Alvarez. All rights reserved.
//

import UIKit

class puntodeinteresTableroCell: UITableViewCell {

    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var imageLugar: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var markbook: UIButton?
    @IBOutlet weak var userInfoLabel: UILabel?
    var puntodeinteres : PuntoDeInteresTablero!

    
    
    func configureCell(_ puntodeinteres: PuntoDeInteresTablero, userLabel: String = "Desconocido",  inicio: Bool = true){
        self.puntodeinteres = puntodeinteres
        titulo.text = self.puntodeinteres._titulo
        categoria.text = self.puntodeinteres._categoria
        direccion.text = self.puntodeinteres._direccion
        precio.text = self.puntodeinteres._precio
       
        if !puntodeinteres._photo.isEmpty,let url = URL(string: puntodeinteres._photo){
            self.imageLugar.kf.setImage(with: url)
        }
        likesCount.text = "\(self.puntodeinteres._likes)"
        
        if !self.puntodeinteres._date.isEmpty{
            self.fecha.text = String.formatBy(dateString: self.puntodeinteres._date)
        } else {
            self.fecha.text = "Sin fecha asignada"
        }
        if puntodeinteres._bookmark{
            let image = #imageLiteral(resourceName: "hifivalen25-11").withRenderingMode(.alwaysTemplate)
            markbook?.setImage(image, for: .normal)
        } else {
            let image = #imageLiteral(resourceName: "hifivalen25-9").withRenderingMode(.alwaysTemplate)
            markbook?.setImage(image, for: .normal)
        }
        userInfoLabel?.text = userLabel
        markbook?.tintColor = UIColor.hexStringToUIColor(hex: "00B19C")
    }
    
    @IBAction func markbookLocation(_ sender: UIButton) {
        if !puntodeinteres._bookmark{
            let image = #imageLiteral(resourceName: "hifivalen25-11").withRenderingMode(.alwaysTemplate)
            markbook?.setImage(image, for: .normal)
        } else {
            let image = #imageLiteral(resourceName: "hifivalen25-9").withRenderingMode(.alwaysTemplate)
            markbook?.setImage(image, for: .normal)
        }
         self.puntodeinteres._bookmark = !self.puntodeinteres._bookmark
         markbook?.tintColor = UIColor.hexStringToUIColor(hex: "00B19C")
    }
    
    
    
    
}
