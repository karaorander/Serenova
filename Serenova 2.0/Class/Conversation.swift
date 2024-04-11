//
//  Conversation.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

// Global User Variable
var currConvo: Conversation?


class Conversation {
    //var participantOne: User?
    //var participantTwo: User?
    public var participants: [String] = []
    public var messages: [Message] = []
    public var convoId: String = ""
    public var numParticipants = -1;
    
    //public var givenParticipant: String = ""
    //public var firstMessage: String = ""
    
    init(participants: [String]) {
        self.participants = participants
        //self.titleAsArray = title.lowercased().split(separator: " ").map { String($0) }
        //self.content = content
    }

    func addMessage(_ messageToAdd: Message) {
        messages.append(messageToAdd)
    }
}
