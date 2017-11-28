/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Photos
import Firebase
import CoreLocation
import Alamofire

class ChatViewController: UIViewController {
  
  @IBOutlet weak var chatBar: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var indicator: UIActivityIndicatorView!

  var channelRef: DatabaseReference!
  fileprivate lazy var messageRef: DatabaseReference = self.channelRef.child("messages")
  fileprivate lazy var userIsTypingRef: DatabaseReference = self.channelRef.child("typingIndicator").child(CurrentUser.shared?._id ?? "")
  fileprivate lazy var usersTypingQuery: DatabaseQuery = self.channelRef.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
  fileprivate var newMessageRefHandle: DatabaseHandle?

  var locManager = CLLocationManager()
    
  fileprivate var messages: [MessageContent] = []
  fileprivate var localTyping = false
  var channel: Channel!

  var isTyping: Bool {
    get {
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.chatBar.delegate = self
    locManager.delegate = self
    locManager.desiredAccuracy = kCLLocationAccuracyBest
    self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "01B29D")
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 180
    self.indicator.stopAnimating()
    observeMessages()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    observeTyping()
  }
    
  deinit {
    if let refHandle = newMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  private func observeMessages() {
    let messageQuery = messageRef.queryLimited(toLast:25)
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
        let messageData = snapshot.value as! Dictionary<String, Any>
        if let id = messageData["user_id"] as? String, let name = messageData["user"] as? String, let text = messageData["text"] as? String, text.characters.count > 0, let date =  messageData["date"] as? String{
            self.messages.append(MessageContent(id: snapshot.key, user_id: id, mensaje: text, usuario: name, fecha: date))
            self.tableView.reloadData()
        } else if let id = messageData["user_id"] as? String, let name = messageData["user"] as? String, let date =  messageData["date"] as? String, let url = messageData["imagenUrl"] as? String  {
            self.messages.append(MessageContent(id: snapshot.key, user_id: id, usuario: name, imagenUrl: url, fecha: date))
            self.tableView.reloadData()
        } else if let id = messageData["user_id"] as? String, let name = messageData["user"] as? String, let date =  messageData["date"] as? String, let poi = messageData["poi"] as? String{
            self.messages.append(MessageContent(id: snapshot.key, user_id: id, usuario: name, poi: poi, fecha: date))
            self.tableView.reloadData()
        } else {
            print("todavia no")
        }
    })
    
  }
   
    // mensaje logic
    @IBAction func sendMenssage(_ sender: Any) {
       guard let user = CurrentUser.shared, let text = chatBar.text, !text.isEmpty  else {
            self.chatBar.text = ""
            return
        }
      messageRef.childByAutoId().setValue([ "text": text,
                         "date": Date().formatDate(format: kFullTime2),
                         "user_id": user._id,
                         "user": user._username])
        self.channelRef.child("last_messages").setValue([ "text": text,
                                   "user": user._username])
        self.chatBar.resignFirstResponder()
        self.chatBar.text = ""
        AudioServicesPlaySystemSound(1001)
        isTyping = false
    }
    
    private func observeTyping() {
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(CurrentUser.shared?._id ?? "")
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
        }
    }

}
  
 
extension ChatViewController: UITextFieldDelegate{
    private func textFieldDidBeginEditing(_ textField: UITextField) -> Bool{
        self.isTyping = true
        return true
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField) -> Bool{
        self.isTyping = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
}


// MARK: Image Picker Delegate -- Image logic
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func eventCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "07B49F")
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .overFullScreen
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            UIAlertController.presentViewController(title: "", message: "La aplicacion no posee el permiso de la galeria, activalo en configuraciones", view: self)
        }
    }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    var chosenImage : UIImage? = nil
        if let chosenEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            chosenImage = chosenEditedImage
        }else if let chosenOriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chosenImage = chosenOriginalImage
        }
        if let chosenImage = chosenImage{
          self.uploadImage(image: chosenImage)
        }
    picker.dismiss(animated: true, completion:nil)
}

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
  }

 func uploadImage(image: UIImage){
        guard let data = UIImagePNGRepresentation(image) as NSData?, let user = CurrentUser.shared else {
            UIAlertController.presentViewController(title: "Error", message: "No se pudo enviar el mensaje", view: self, OkLabel: "Aceptar", successEvent: { evento in
                _ =  self.navigationController?.popViewController(animated: true)
            })
            return
        }
    self.indicator.startAnimating()
        let message = messageRef.childByAutoId()
        let riversRef = Storage.storage().reference().child("channels/\(self.channel.id)/message/\(message.key).jpg")
        _ = riversRef.putData(data as Data, metadata: nil) { (metadata, error) in
            guard let meta = metadata else {
                UIAlertController.presentViewController(title: "Error", message: "No se pudo enviar el mensaje", view: self, OkLabel: "Aceptar", successEvent: { evento in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                return
            }

            message.setValue(["imagenUrl": meta.downloadURL()?.absoluteString ?? meta.path ?? "",
                         "date": Date().formatDate(format: kFullTime2),
                         "user_id": user._id,
                         "user": user._username])
            self.channelRef.child("last_messages").setValue(["imagenUrl": meta.downloadURL()?.absoluteString ?? meta.path ?? "",
                                      "user": user._username])
            self.channelRef.child("images").child(message.key).setValue(meta.downloadURL()?.absoluteString ?? meta.path ?? "")
            AudioServicesPlaySystemSound(1001)
            self.indicator.stopAnimating()
            }
    
    
  }
}

// Cell logic
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mensaje = messages[indexPath.row]
        let type = MessageContent.getType(body: mensaje, id: CurrentUser.shared?._id ?? "")
        let separatorFlag: (Bool,Bool) = MessageContent.getFormatSeparator(list: messages, index: indexPath.row)
        switch type {
            case .checkIn(let type):
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkIn" + (type ? "B" : "A"), for: indexPath) as! CheckInMessageTableViewCell
                cell.loadInfo(mensaje, actual: type, inicio: separatorFlag.0, final: separatorFlag.1)
                cell.selectionStyle = .none
                return cell
            case .board(let type, let punto):
                let cell = tableView.dequeueReusableCell(withIdentifier: "tableroCell" + (type ? "B" : "A"), for: indexPath) as! puntodeinteresTableroCell
                cell.configureCell(punto, lat: 0.0, lon: 0.0, userLabel: type ? "yo" : mensaje.usuario, inicio: separatorFlag.0)
                cell.selectionStyle = .none
                return cell
            case .image(let type):
                let cell = tableView.dequeueReusableCell(withIdentifier: "photoMensaje" + (type ? "B" : "A"), for: indexPath) as! PhotoMessageTableViewCell
                cell.loadInfo(mensaje, actual: type, inicio: separatorFlag.0, final: separatorFlag.1)
                cell.selectionStyle = .none
                return cell
            case .simple(let type):
                let cell = tableView.dequeueReusableCell(withIdentifier: "simpleMessage" + (type ? "B" : "A"), for: indexPath) as! SimpleMessageTableViewCell
                cell.loadInfo(mensaje, actual: type, inicio: separatorFlag.0, final: separatorFlag.1)
                cell.selectionStyle = .none
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = MessageContent.getType(body: messages[indexPath.row], id: CurrentUser.shared?._id ?? "")
        switch type {
        case .checkIn( _):
            return UITableViewAutomaticDimension
        case .board( _, _):
            return UITableViewAutomaticDimension
        case .image( _):
            return UITableViewAutomaticDimension
        case .simple( _):
            return UITableViewAutomaticDimension
        }
    }
    
}


// CheckIn logic
extension ChatViewController: CLLocationManagerDelegate{
    
    
    @IBAction func eventCheckIn(_ sender: Any) {
        self.indicator.startAnimating()
        locManager.requestLocation()
    }
    
    func consultarApi(latitude: String, longitude: String){
        let body = ["coordenada":[
            "lat": latitude,
            "lon": longitude
            ]]
        
        let ruta = KRutaMain + "/base/api/where_am_i/"
        
        Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let result = response.result.value as? [String:Any],
                let name = result["name"] as? String,
                let locality_id = result["id"] as? Int
                else {
                    self.indicator.stopAnimating()
                    UIAlertController.presentViewController(title: "Error", message: "No se pudo hace checkIn", view: self, OkLabel: "Aceptar", successEvent: { evento in
                    })
                    return
            }
            self.consultarApi(name: name, id_sitio: "\(locality_id)")
            
        }
    }
    
    func consultarApi(name: String, id_sitio: String){
        if !id_sitio.isEmpty, let user = CurrentUser.shared{
            var body:[String: Any] = [:]
            body["tourist_id"] = user._uid
            body["poi_id"] = id_sitio
            let ruta = KRutaMain + "/perfil/API/checkin/"
            Alamofire.request(ruta, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                guard 200...300 ~= (response.response?.statusCode ?? -999)
                    else {
                        self.indicator.stopAnimating()
                        UIAlertController.presentViewController(title: "Error", message: "No se pudo hacer CheckIn en el sitio", view: self)
                        return
                }
                self.indicator.stopAnimating()
                self.messageRef.childByAutoId().setValue([ "poi": name,
                                                      "date": Date().formatDate(format: kFullTime2),
                                                      "user_id": user._id,
                                                      "user": user._username])
                self.channelRef.child("last_messages").setValue([ "poi": name,
                                      "user": user._username])
            }
        } else {
            self.indicator.stopAnimating()
            UIAlertController.presentViewController(title: "Error", message: "No se pudo hacer CheckIn en el sitio", view: self)
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let last = locations.last{
            self.consultarApi(latitude: "\(last.coordinate.latitude)", longitude: "\(last.coordinate.longitude)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error localizacion")
        self.indicator.stopAnimating()
        UIAlertController.presentViewController(title: "Error", message: "No se pudo obtener la ubicacion actual para hacer el checkIn", view: self, OkLabel: "Aceptar", successEvent: { evento in
        })
    }
    
}

