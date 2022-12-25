import UIKit

class NewNoteViewController: UIViewController {
    
    // MARK: - Lyfecycle

    @IBOutlet private var noteTextView: UITextView!
    
    public var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTextView.becomeFirstResponder()
        
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
