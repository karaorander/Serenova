class Message {
    var messageContent = ""
    var timestamp: Int = -1
    var sender: User?
    var recipient: User?
    var isSent: Bool = false
    
    init() {}
}
