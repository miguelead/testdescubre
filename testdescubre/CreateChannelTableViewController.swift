//
//  CreateChannelTableViewController.swift
//  ChatChat
//
//  Created by Momentum Lab 1 on 11/10/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateChannelTableViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var channelRefHandle: DatabaseHandle?
    fileprivate var usersRefHandle: DatabaseHandle?
    fileprivate var userslist: [Users] = []
    fileprivate var nameChannel: String?
    fileprivate var imageChannel: UIImage?
    fileprivate var userSelect: [Users] = []

   
    
    private lazy var usersRef: DatabaseReference = Database.database().reference().child("users")
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.stopAnimating()
        observeChannels()
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
        if let userRefHandle = usersRefHandle {
            usersRef.removeObserver(withHandle: userRefHandle)
        }
    }
    
    @IBAction func createChannel(_ sender: Any) {
        if let name = nameChannel, name.characters.count > 5{
    
            self.indicator.startAnimating()
            var userMap = self.userSelect.reduce([String:[String: Any]](), { (list, user) -> [String:Any] in
                var ret = list
                ret[user.id] = ["name": user.name, "uid": user.id]
                return ret
            })
            
            userMap[CurrentUser.shared?._id ?? ""] = ["name": CurrentUser.shared?._username ?? "", "uid": CurrentUser.shared?._id ?? ""]
            let channel = channelRef.childByAutoId()
            channel.setValue(["name" : name, "users": userMap])
            if let image = imageChannel {
                uploadImage(id: channel.key, image: image)
            } else{
                self.indicator.stopAnimating()
                UIAlertController.presentViewController(title: "Registro Exitoso", message: "La sala de chat se registro con exito", view: self, OkLabel: "Aceptar", successEvent: { evento in
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }
    }

    
    func uploadImage(id: String, image: UIImage){
        guard let data = UIImagePNGRepresentation(image) as NSData? else {
            self.indicator.stopAnimating()
            UIAlertController.presentViewController(title: "Registro casi Exitoso", message: "Se registro sala de chat, pero la imagen no pudo ser cargada", view: self, OkLabel: "Aceptar", successEvent: { evento in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child(id + "/icons/iconChannel.jpg")
        _ = riversRef.putData(data as Data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                self.indicator.stopAnimating()
                UIAlertController.presentViewController(title: "Registro casi Exitoso", message: "Se registro sala de chat, pero la imagen no pudo ser cargada", view: self, OkLabel: "Aceptar", successEvent: { evento in
                    self.navigationController?.popViewController(animated: true)
                })
                
                return
            }
            self.indicator.stopAnimating()
            UIAlertController.presentViewController(title: "Registro Exitoso", message: "La sala de chat se registro con exito", view: self, OkLabel: "Aceptar", successEvent: { evento in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    @IBAction func cancelOperation(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func observeChannels() {
        usersRefHandle = usersRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as? String, name.characters.count > 0, id != CurrentUser.shared?._id ?? ""  {
                self.userslist.append(Users(id: id, name: name, image: channelData["icon"] as? String))
                self.tableView.reloadData()
            }
        })
    }
}

extension CreateChannelTableViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : userslist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectNameCell", for: indexPath) as! NameChannelTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! UserSelectChannelTableViewCell
        cell.nameCell.text = userslist[indexPath.row].name
        cell.userIndex = indexPath.row
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Agregar a un compañero"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120.0
        } else{
            return 50.0
        }
    }
}


extension CreateChannelTableViewController: nameDelegate{
    func addChannelName(name: String){
        self.nameChannel = name
    }
    
    func addImageChannel(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "F6F6F8")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .overFullScreen
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            UIAlertController.presentViewController(title: "", message: "La aplicacion no posee el permiso de la galeria, activalo en configuraciones", view: self)
        }
    }
}

extension CreateChannelTableViewController : UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage : UIImage? = nil
        if let chosenEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            chosenImage = chosenEditedImage
        }else if let chosenOriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chosenImage = chosenOriginalImage
        }
        if let chosenImage = chosenImage{
            self.imageChannel = chosenImage
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? NameChannelTableViewCell
            cell?.channelsImage?.image = chosenImage
           
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}

extension CreateChannelTableViewController: userSelectDelegate{
    func selectUser(index: Int, status: Bool){
        if status{
            self.userSelect.append(self.userslist[index])
        } else if let selectIndex = self.userSelect.index(where: {$0.id == self.userslist[index].id}){
            self.userSelect.remove(at: selectIndex)
        }
        
    }
}