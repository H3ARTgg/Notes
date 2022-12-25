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
            /// ↑   Для создания новой заметки, делает поле активным для ввода
        } else {
            noteTextView.text = noteText
            /// ↑   Для показа заметки
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            returnText()
            newNote = false
        }
        /// ↑   Как только почти скрылся контроллер, текст передаается в замыкание
    }
    
    // MARK: - Private functions

    private func returnText() {
        !noteTextView.text.isEmpty ? completion?(noteTextView.text) : completion?("")
    }
}
