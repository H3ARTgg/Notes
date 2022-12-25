import UIKit

// Класс для кастомной ячейки
class NoteCellWithButton: UITableViewCell {
    
    // MARK: - Lifecycle
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellButton: ButtonCheckbox!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
