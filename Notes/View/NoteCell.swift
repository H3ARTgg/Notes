import UIKit

class NoteCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            cellView.backgroundColor = .secondarySystemBackground
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let self = self else { return }
                
                self.cellView.backgroundColor = .systemBackground
            }
            /// ↑   Если на ячейку нажали, то view выделяется светло-серым цветом, и спустя 0.4 секунды ячейка ставится обратно белой
        } else {
            cellView.backgroundColor = .systemBackground
        }
    }
}
