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


class ChannelListViewController: UITableViewController {

    
  private var channelRefHandle: DatabaseHandle?
  private var channels: [Channel] = []
  
  private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Planes"
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    observeChannels()
  }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }


  // MARK: Firebase related methods

  private func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
      let channelData = snapshot.value as! Dictionary<String, AnyObject>
      let id = snapshot.key
      if let name = channelData["name"] as? String, name.characters.count > 0 {
        var last_message = (channelData["messages"] as? [String: Any])?.reversed().first?.value as? [String: Any]
        var info :String? = nil
        if let lst_mssage = last_message{
            info = lst_mssage.keys.contains("photoURL") ? "Ha enviado una imagen" : last_message?["text"] as? String
        }
        self.channels.append(Channel(id: id, name: name, owner: last_message?["senderName"] as? String, details: info))
        self.tableView.reloadData()
      } else {
        print("Error! Could not decode channel data")
      }
    })
  }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    if let channel = sender as? Channel {
      let chatVc = segue.destination as! ChatViewController
      chatVc.senderDisplayName = CurrentUser.shared?._nombre ?? ""
      chatVc.channel = channel
      chatVc.channelRef = channelRef.child(channel.id)
    }
  }
  
  // MARK: UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return channels.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingChannel", for: indexPath) as! DataChannelCell
    cell.titleLabel.text = channels[indexPath.row].name
    cell.ownerData.text = channels[indexPath.row].owner
    cell.lastMessageData.text = channels[indexPath.row].details
    return cell
  }

  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let channel = channels[indexPath.row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
  }
}
