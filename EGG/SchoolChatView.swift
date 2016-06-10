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
    
    var messages = [Message]()
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
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {

            return true
        
    }
    
    func setupFirebase() {
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryLimitedToFirst(25).observeEventType(.ChildAdded, withBlock: { (snapshot) in
//        })
//        messagesRef.queryLimitedToNumberOfChildren(25).observeEventType(.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value!["text"] as? String
            let sender = snapshot.value!["sender"] as? String
            //let imageUrl = snapshot.value["imageUrl"] as? String
            
            let message = Message(text: text, sender: sender)//, imageUrl: imageUrl)
            self.messages.append(message)
            self.finishReceivingMessage()
        })
    }
    
    func sendMessage(text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender
            //"imageUrl":senderImageUrl
            ])
    }
    
    func tempSendMessage(text: String!, sender: String!) {
        let message = Message(text: text, sender: sender)//, imageUrl: senderImageUrl)
        messages.append(message)
    }
    
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        //        if let stringUrl = imageUrl {
        //            if let url = NSURL(string: stringUrl) {
        //                if let data = NSData(contentsOfURL: url) {
        //                    let image = UIImage(data: data)
        //                    let diameter = incoming ? UInt(collectionView!.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
        //                    let avatarImage = JSQMessagesAvatarFactory.avatarWithImage(image, diameter: diameter)
        //                    avatars[name] = avatarImage
        //                    return
        //                }
        //            }
        //        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        
        let diameter = incoming ? UInt(collectionView!.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView!.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = name.characters.count
        let initials : String? = name.substringToIndex(senderId.startIndex.advancedBy(min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        avatars[name] = userImage
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBubbles()
        automaticallyScrollsToMostRecentMessage = true
        
        inputToolbar!.contentView!.leftBarButtonItem = nil
        
        //navigationController?.navigationBar.topItem?.title = "Logout"
        senderId = (senderId != nil) ? senderId : "Anonymous"
        senderId = passValue
        senderDisplayName = FIRAuth.auth()?.currentUser?.email
        //let profileImageUrl = user?.providerData["cachedUserProfile"]?["profile_image_url_https"] as? NSString
        
        //        if let urlString = profileImageUrl {
        //            setupAvatarColor(sender, imageUrl: urlString as String, incoming: false)
        //            senderImageUrl = urlString as String
        //        } else {
        setupAvatarColor(senderId, incoming: false)
        //senderImageUrl = ""
        // }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SchoolChatViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        tap.delegate = self
        self.collectionView?.addGestureRecognizer(tap)
        
        setupFirebase()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView!.collectionViewLayout.springinessEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //view will disappear not written yet
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text, sender: senderId)
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
//
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if message.senderId() == senderId {
            return UIImageView(image: outgoingBubbleImageView.messageBubbleImage, highlightedImage: outgoingBubbleImageView.messageBubbleHighlightedImage)
//            return UIImageView(image: outgoingBubbleImageView.messageBubbleImage, highlightedImage: outgoingBubbleImageView.messageBubbleHighlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.messageBubbleImage, highlightedImage: incomingBubbleImageView.messageBubbleHighlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
//
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        if let avatar = avatars[message.senderId()] {
            return UIImageView(image: avatar.avatarImage)
        } else {
            setupAvatarColor(message.senderId(), incoming: false)
            return UIImageView(image:avatars[message.senderId()]?.avatarImage)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderId() == senderId {
            cell.textView!.textColor = UIColor.blackColor()
        } else {
            cell.textView!.textColor = UIColor.whiteColor()
        }
        
        let attributes = [NSForegroundColorAttributeName:cell.textView!.tintColor, NSUnderlineStyleAttributeName: 1]
        
        cell.textView!.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderId() == senderId {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderId())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId() == senderId {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
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
