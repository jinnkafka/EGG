//
//  CourseChatView.swift
//  EGG
//
//  Created by Yuan Fu on 3/19/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseAuth

class SchoolChatViewController: JSQMessagesViewController, UIGestureRecognizerDelegate{
    
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    //var senderImageUrl: String! //???
    var batchMessages = true
    var passValue: String = ""
    // *** STEP 1: STORE FIREBASE REFERENCES

    var messagesRef:FIRDatabaseReference!
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleLightGray())
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

            return true
        
    }
    
    func setupFirebase() {
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryOrderedByKey().queryLimited(toLast: 25).observe(.childAdded, with: { (snapshot) in
            let text = snapshot.value!["text"] as? String
            let sender = snapshot.value!["sender"] as? String
            //let imageUrl = snapshot.value["imageUrl"] as? String
            
            let message = JSQMessage(senderId: sender, displayName: sender, text: text)!
            self.messages.append(message)
            self.finishReceivingMessage()
        })
    }
    
    func sendMessage(_ text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender
            ])
    }
    
    func tempSendMessage(_ text: String!, sender: String!) {
        let message = JSQMessage(senderId: sender, displayName: sender, text: text)!
        messages.append(message)
    }
    
    
    func setupAvatarImage(_ name: String, imageUrl: String?, incoming: Bool) {
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(_ name: String, incoming: Bool) {
        
        let diameter = incoming ? UInt(collectionView!.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = name.characters.count
        let initials : String? = (name as NSString).substring(to: min(3, nameLength))
        let userImage = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: initials, backgroundColor: color, textColor: UIColor.black(), font: UIFont.systemFont(ofSize: CGFloat(13)), diameter: diameter)
        avatars[name] = userImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbles()
        automaticallyScrollsToMostRecentMessage = true
        inputToolbar!.contentView!.leftBarButtonItem = nil
        senderId = (senderId != nil) ? senderId : "Anonymous"
        senderId = passValue
        senderDisplayName = FIRAuth.auth()?.currentUser?.email
        setupAvatarColor(senderId, incoming: false)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SchoolChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
        self.collectionView?.addGestureRecognizer(tap)
        
        setupFirebase()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //view will disappear not written yet
    
    func receivedMessagePressed(_ sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottom(animated: true)
    }
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text, sender: senderId)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Camera pressed!")
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item!]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item!]
        if message.senderId == senderId {
            return UIImageView(image: outgoingBubbleImageView.messageBubbleImage, highlightedImage: outgoingBubbleImageView.messageBubbleHighlightedImage)
        }
        return UIImageView(image: incomingBubbleImageView.messageBubbleImage, highlightedImage: incomingBubbleImageView.messageBubbleHighlightedImage)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item!]
        if let avatar = avatars[message.senderId] {
            return UIImageView(image: avatar.avatarImage)
        } else {
            setupAvatarColor(message.senderId, incoming: false)
            return UIImageView(image:avatars[message.senderId]?.avatarImage)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[(indexPath as NSIndexPath).item]
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.black()
        } else {
            cell.textView!.textColor = UIColor.white()
        }
        let attributes = [NSForegroundColorAttributeName:cell.textView!.tintColor, NSUnderlineStyleAttributeName: 1]
        cell.textView!.linkTextAttributes = attributes
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> AttributedString! {
        let message = messages[indexPath.item!];
        
        // Sent by me, skip
        if message.senderId == senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item! - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
        }
        
        return AttributedString(string:message.senderId)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = messages[indexPath.item!]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item! - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}

extension UIImageView: JSQMessageBubbleImageDataSource, JSQMessageAvatarImageDataSource{
    public func messageBubbleImage() -> UIImage!{
        return image!
    }
    public func messageBubbleHighlightedImage() -> UIImage!{
        return (highlightedImage != nil) ? highlightedImage! : image!
    }
    public func avatarImage() -> UIImage{
        return image!
    }
    public func avatarHighlightedImage() -> UIImage!{
        return (highlightedImage != nil) ? highlightedImage! : image!
    }
    public func avatarPlaceholderImage() -> UIImage!{
        return image!
    }
}
