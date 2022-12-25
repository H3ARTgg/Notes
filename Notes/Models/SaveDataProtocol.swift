protocol SaveDataProtocol: AnyObject {
    var notes: [Note] { get }
    func store(notes: [Note])
}
