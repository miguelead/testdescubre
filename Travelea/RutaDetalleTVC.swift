//
//  RutaDetalleTVC.swift
//  Travelea
//
//  Created by Momentum Lab 2 on 11/27/17.
//  Copyright © 2017 MomentumLab. All rights reserved.
//

import UIKit

class RutaDetalleTVC: UITableViewController {
    
    var listaobjetos: [Any] = []

     override func viewDidLoad() {
        super.viewDidLoad()
        
        listaobjetos.removeAll()
        
        listaobjetos.append(AutorRutaDeInteresDetalle.init(tituloruta: "¡Las mejores rutas de Puerto Ordaz!", subtituloruta: "Mis favoritos por su atención y su ambiente", descripcionruta: "Incluye Casa de té, Restaurantes. Pastelerías", photo: "https://pbs.twimg.com/profile_images/718588760003383296/2AG8omMO_400x400.jpg", nombre: "Ligia Valles", descripcionautor: "Periodista de profesión, viajera de oficio, fotógrafa de costumbre"))
        
        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet3", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "", telf: "", mail: "", web: "", info: "LGourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes"))
        
        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet4", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "", telf: "", mail: "", web: "", info: "LGourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes"))
        
        
        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet5", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "", telf: "", mail: "", web: "", info: "LGourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes"))
        
        
        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet6", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "", telf: "", mail: "", web: "", info: "LGourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes"))
        
        
        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet7", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "", telf: "", mail: "", web: "", info: "LGourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes"))
        
        
//        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet2", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "https://ig-s-b-a.akamaihd.net/h-ak-igx/t51.2885-15/e35/23596048_1991899304357545_4015220519639973888_n.jpg", telf: "", mail: "", web: "", info: "L'Gourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes adquirir en la ciudad. ¡Su café de carrapia combina muy bien con las arepas! Llama con anticipación para reservas mesas"))
//        
//        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet3", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "https://ig-s-b-a.akamaihd.net/h-ak-igx/t51.2885-15/e35/23596048_1991899304357545_4015220519639973888_n.jpg", telf: "", mail: "", web: "", info: "L'Gourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes adquirir en la ciudad. ¡Su café de carrapia combina muy bien con las arepas! Llama con anticipación para reservas mesas"))
//
//        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet4", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "https://ig-s-b-a.akamaihd.net/h-ak-igx/t51.2885-15/e35/23596048_1991899304357545_4015220519639973888_n.jpg", telf: "", mail: "", web: "", info: "L'Gourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes adquirir en la ciudad. ¡Su café de carrapia combina muy bien con las arepas! Llama con anticipación para reservas mesas"))
//
//        listaobjetos.append(RutaDeInteresDetalle.init(titulo: "L´Gourmet5", categoria: "Casa de té, Restaurante, Pastelería", direccion: "Centro Cívico Edif. Alpes", photo: "https://ig-s-b-a.akamaihd.net/h-ak-igx/t51.2885-15/e35/23596048_1991899304357545_4015220519639973888_n.jpg", telf: "", mail: "", web: "", info: "L'Gourmet tiene una excelente atención y sus desayunos son de las mejores cosas que puedes adquirir en la ciudad. ¡Su café de carrapia combina muy bien con las arepas! Llama con anticipación para reservas mesas"))
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let elemento = listaobjetos[indexPath.row] as? AutorRutaDeInteresDetalle{
            let cell = tableView.dequeueReusableCell(withIdentifier: "autorrutadetalle", for: indexPath) as! autorrutadetallecell
            cell.selectionStyle = .none
            cell.configureCell(elemento)
            return cell
  
        }
        
        if let elemento = listaobjetos[indexPath.row] as? RutaDeInteresDetalle{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rutadetallecell", for: indexPath) as! rutadetallecell
            cell.selectionStyle = .none
            cell.configureCell(elemento)
            return cell
            
            
        }
        
        return UITableViewCell()
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaobjetos.count
    }
 

}


