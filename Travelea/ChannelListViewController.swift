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
import Firebase
import Kingfisher


class ChannelListViewController: UIViewController {

    
  @IBOutlet weak var tableView: UITableView!
  
  fileprivate var channels: [Channel] = []
  fileprivate lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
  fileprivate lazy var channel_UserRef: DatabaseReference = Database.database().reference().child("channels_users")
  fileprivate var channelRefHandle: DatabaseHandle?
  fileprivate var channel_UserRefHandle: DatabaseHandle?
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Planes"
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.addBackgroundImage(message: "")
    observeChannels()
  }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }


    func addBackgroundImage(message: String = "¿No tienes un plan disponible? crea uno"){
        let image = #imageLiteral(resourceName: "emptystate-13").withRenderingMode(.alwaysTemplate)
        let topMessage = "Arma tu Combo de amigos"
        let bottomMessage = message
        let emptyBackgroundView = EmptyBackgroundView(image: image, top: topMessage, bottom: bottomMessage)
        self.tableView.backgroundView = emptyBackgroundView
    }

  private func observeChannels() {
    channel_UserRefHandle = channel_UserRef.child(CurrentUser.shared?._id ?? "").observe(.value, with: { (snapshots) in
        self.channels = []
        for child in snapshots.children.allObjects  as? [DataSnapshot] ?? []{
            self.channelRefHandle = self.channelRef.child(child.key).observe(.value, with: { (snapshot) -> Void in
                    let channelData = snapshot.value as? Dictionary<String, AnyObject>
                    if let name = channelData?["name"] as? String, name.characters.count > 0 {
                        var last_message = (channelData?["messages"] as? [String: Any])?.reversed().first?.value as? [String: Any]
                        var info :String? = nil
                        if let lst_mssage = last_message{
                            info = lst_mssage.keys.contains("photo") ? "Ha enviado una imagen" : last_message?["text"] as? String
                        }
                        if let index = self.channels.index(where: { channel in return channel.id == child.key}){
                            self.channels[index] = Channel(id: child.key, name: name, owner: last_message?["user"] as? String, details: info, image: channelData?["icon"] as? String)
                        } else {
                            self.channels.append(Channel(id: child.key, name: name, owner: last_message?["user"] as? String, details: info, image: channelData?["icon"] as? String))
                        }
                    }
                if self.channels.isEmpty{
                    self.addBackgroundImage()
                } else {
                    self.tableView.backgroundView = nil
                }
                self.tableView.reloadData()
            })
        }
    })
}
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if let channel = sender as? Channel, let chatVc = segue.destination as? ChatMainViewController {
      chatVc.channels = channel
      chatVc.channelRef = channelRef.child(channel.id)
    }
  }
}

extension ChannelListViewController: UITableViewDelegate, UITableViewDataSource{
  // MARK: UITableViewDataSource
  
   func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return channels.count
  }
  
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingChannel", for: indexPath) as! DataChannelCell
    cell.titleLabel.text = channels[indexPath.row].name
    if !channels[indexPath.row].owner.isEmpty{
        cell.ownerData.text = channels[indexPath.row].owner
    } else if channels[indexPath.row].details.isEmpty{
        cell.ownerData.text = "La sala acaba de ser creada"
    } else {
        cell.ownerData.text = "Desconocido"
    }
    if !channels[indexPath.row].image.isEmpty, let url = URL(string: channels[indexPath.row].image){
        cell.userIcon.kf.setImage(with: url)
    }
    cell.selectionStyle = .none
    cell.lastMessageData.text = channels[indexPath.row].details
    return cell
  }

  // MARK: UITableViewDelegate
  
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let channel = channels[indexPath.row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
  }
}
