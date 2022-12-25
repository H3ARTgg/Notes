import UIKit

class ButtonCheckbox: UIButton {
    private let checkbox = UIImage(systemName: "circle")
    private let filledCheckbox = UIImage(systemName: "circle.fill")

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(filledCheckbox, for: .normal)
            } else {
                self.setImage(checkbox, for: .normal)
            }
        }
    }
    /// ↑   В зависимости от состояния ячейки (выбрано, не выбрано), меняем внешний вид кнопки

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.isUserInteractionEnabled = false
        /// ↑   Отключаем взаимодействие с кнопкой, так как все будет происходить с didSelectRowAt
    }
}
