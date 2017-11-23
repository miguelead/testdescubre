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
  

  var channelRef: DatabaseReference!

  private lazy var messageRef: DatabaseReference = self.channelRef.child("messages")
  fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://testfirebase-bcb3a.appspot.com")
  private lazy var userIsTypingRef: DatabaseReference = self.channelRef.child("typingIndicator").child(CurrentUser.shared?._id ?? "")
  private lazy var usersTypingQuery: DatabaseQuery = self.channelRef.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

  private var newMessageRefHandle: DatabaseHandle?
  private var updatedMessageRefHandle: DatabaseHandle?
  
  private var messages: [MessageContent] = []
 
  private var localTyping = false
  var channel: Channel? {
    didSet {
      title = channel?.name
    }
  }

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
    self.navigationController?.navigationBar.tintColor = UIColor.hexStringToUIColor(hex: "01B29D")
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
    messageRef = channelRef!.child("messages")
    let messageQuery = messageRef.queryLimited(toLast:25)
    
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
      _ = snapshot.value as! Dictionary<String, String>
    
    })
    
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
  
 
extension ChatViewController: UITextViewDelegate{
  func textViewDidChange(_ textView: UITextView) {
    isTyping = textView.text != ""
  }

}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion:nil)
}

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
  }
}
