//
//  Message.swift
//  EGG
//
//  Created by Yuan Fu on 3/19/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class Message : NSObject, JSQMessageData {
    var text_: String
    var sender_: String
    var date_: Date
    var imageUrl_: String?
    
    convenience init(text: String?, sender: String?) {
        self.init(text: text, sender: sender, imageUrl: nil)
    }
    
    init(text: String?, sender: String?, imageUrl: String?) {
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = Date()
        self.imageUrl_ = imageUrl
    }
    func senderDisplayName() -> String! {
        return sender_
    }
    func text() -> String! {
        return text_;
    }
    
    func senderId() -> String! {
        return sender_;
    }
    
    func date() -> Date! {
        return date_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
    func isMediaMessage() -> Bool {
        return false
    }
    func messageHash() -> UInt {
        return 0
    }
//    func media() -> JSQMessageMediaData! {
//        
//    }
}
