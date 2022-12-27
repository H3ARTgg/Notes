protocol NoteToolbarProtocol {
    var toolbarDelegate: NoteToolbarDelegate? { get set }
    
    init(delegate: NoteToolbarDelegate)
    
}
