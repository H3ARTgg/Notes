import UIKit

// Для кастомного Toolbar, создаем кнопки и передаем действия в делегат
class NoteToolbar: UIToolbar, NoteToolbarProtocol {
    
    var toolbarDelegate: NoteToolbarDelegate?
    
    required init(delegate: NoteToolbarDelegate) {
        super.init(frame: .zero)
        
        self.toolbarDelegate = delegate
        self.sizeToFit()
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: .none)

        let boldButton = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, target: self, action: #selector(didBoldButtonTapped))
        
        let italicButton = UIBarButtonItem(image: UIImage(systemName: "italic"), style: .done, target: self, action: #selector(didItalicButtonTapped))
        
        fixedSpace.width = 30.0
        boldButton.width = 20.0
        italicButton.width = 20.0
            
        self.setItems([boldButton, fixedSpace, italicButton], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    @objc private func didBoldButtonTapped() {
        toolbarDelegate?.didBoldButtonTapped()
    }
    
    @objc private func didItalicButtonTapped() {
        toolbarDelegate?.didItalicButtonTapped()
    }
    
    
}
