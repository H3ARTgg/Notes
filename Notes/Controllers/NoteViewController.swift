import UIKit

class NoteViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var noteTextView: UITextView!
    
    public var noteText: String = ""
    public var newNote: Bool = false
    public var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newNote {
            noteTextView.becomeFirstResponder()
        } else {
            noteTextView.text = noteText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            returnText()
        }
    }
    
    
    // MARK: - Private functions

    private func returnText() {
        !noteTextView.text.isEmpty ? completion?(noteTextView.text) : completion?("")
    }
}
