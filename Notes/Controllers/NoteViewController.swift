import UIKit

class NoteViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var noteTitleLabel: UILabel!
    @IBOutlet private var noteTextView: UITextView!
    
    public var noteTitle: String = ""
    public var noteText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitleLabel.text = noteTitle
        noteTextView.text = noteText
    }

}
