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


class ChatViewController: UIViewController {
  
  @IBOutlet weak var chatBar: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var checkInButtom: UIBarButtonItem!
  @IBOutlet weak var cameraButtom: UIBarButtonItem!
    
  var channelRef: DatabaseReference!
  fileprivate lazy var messageRef: DatabaseReference = self.channelRef.child("messages")
  fileprivate lazy var userIsTypingRef: DatabaseReference = self.channelRef.child("typingIndicator").child(CurrentUser.shared?._id ?? "")
  fileprivate lazy var usersTypingQuery: DatabaseQuery = self.channelRef.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

    
  fileprivate var newMessageRefHandle: DatabaseHandle?
  fileprivate var updatedMessageRefHandle: DatabaseHandle?
  
    
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
    self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "01B29D")
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 500
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
    if let refHandle = updatedMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  private func observeMessages() {
    let messageQuery = messageRef.queryLimited(toLast:25)
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
      _ = snapshot.value as! Dictionary<String, String>
    
    })
    
  }
    
    @IBAction func eventCheckIn(_ sender: Any) {
        UIAlertController.presentViewController(title: "", message: "No hay ningun lugar disponible para hacer checkIn", view: self)
    }
    
    
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
    
    @IBAction func sendMenssage(_ sender: Any) {
       guard let user = CurrentUser.shared, let text = chatBar.text, !text.isEmpty  else {
            UIAlertController.presentViewController(title: "Error", message: "No se pudo enviar el mensaje", view: self, OkLabel: "Aceptar", successEvent: { evento in
                _ =  self.navigationController?.popViewController(animated: true)
            })
            return
        }
      let message = messageRef.childByAutoId()
      message
              .setValue([ "text": text,
                         "date": Date().formatDate(format: kFullTime2),
                         "user_id": user._id,
                         "user": user._username])
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
  
}


// MARK: Image Picker Delegate -- Event with Image
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        let message = messageRef.childByAutoId()
        let storageRef = Storage.storage().reference()
        let riversRef = storageRef.child("channels/\(self.channel.id)/message/\(message.key).jpg")
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
            }
  }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mensaje = messages[indexPath.row]
        if let actualUser = CurrentUser.shared?._id, actualUser == mensaje.user_id{
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleMessageB", for: indexPath) as! SimpleMessageTableViewCell
            cell.textInfo.text = mensaje.mensaje
            cell.titlePrincipal.text = "Yo"
            cell.starIcon.image = UIImage()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "simpleMessageA", for: indexPath) as! SimpleMessageTableViewCell
            cell.textInfo.text = mensaje.mensaje
            cell.titlePrincipal.text = mensaje.usuario
            cell.starIcon.image = UIImage()
            return cell
        }
        
    }
    
}
