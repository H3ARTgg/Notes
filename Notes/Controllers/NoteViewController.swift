import UIKit
import Foundation

class NoteViewController: UIViewController, UITextViewDelegate, NoteToolbarDelegate {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var noteTextView: UITextView!
    
    private var toolbar: NoteToolbar?
    private var isBoldButtonTappedWithoutSelection: Bool = false
    private var isItalicButtonTappedWithoutSelection: Bool = false
    public var noteText: NSAttributedString = NSAttributedString(string: "")
    public var newNote: Bool = false
    public var completion: ((NSAttributedString) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar = NoteToolbar(delegate: self)
        noteTextView.delegate = self
        
        noteTextView.inputAccessoryView = toolbar
        
        if newNote {
            noteTextView.becomeFirstResponder()
            /// ↑   Для создания новой заметки, делает поле активным для ввода
        } else {
            noteTextView.attributedText = noteText
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
    
    // MARK: - TexViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: .none,
            action: #selector(didDoneTapped))
    }
    /// ↑   Как только текст начали редактировать, то показать кнопку "Готово"
    
    func textViewDidEndEditing(_ textView: UITextView) {
        navigationItem.setRightBarButton(nil, animated: false)
    }
    /// ↑   Как только прекратили редактировать текст - убираем кнопку "Готово"
    
    // MARK: - NoteToolbarDelegate
    
    func didBoldButtonTapped() {
        guard let fontSize = noteTextView.font?.pointSize else { return }
        
        let textStorage = noteTextView.textStorage
        let selectedLocation = noteTextView.selectedRange.location
        let selectedRange = noteTextView.selectedRange
        let defaultFont = UIFont.systemFont(ofSize: fontSize)
        
        // Если выделенный диапазон равен нулю и кнопка italic не нажата, то печатем bold, а также при нажатиях переключаемся между обычным и bold
        if selectedRange.length == 0 && !isItalicButtonTappedWithoutSelection {
            if !isBoldButtonTappedWithoutSelection {
                isBoldButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.bold
            } else {
                isBoldButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont
            }
            // Если кнопка italic нажата, то печатаем bold-italic, переключаемся между bold-italic и italic
        } else if selectedRange.length == 0 && isItalicButtonTappedWithoutSelection {
            if !isBoldButtonTappedWithoutSelection {
                isItalicButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.boldItalic
            } else {
                isBoldButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont.italic
            }
        }
        
        // Если что-то выделено
        if selectedRange.length > 0 {
            guard let nowFont = textStorage.attribute(.font, at: selectedLocation, effectiveRange: nil) as? UIFont else { return }
            /// ↑   Получаем UIFont выделенного текста
            
            var resultOfChecking: Int = -1
            /// ↑   0 - default, 1 - italic, 2 - bold, 3 - boldItalic
            
            if nowFont == defaultFont {
                resultOfChecking = 0
            } else if nowFont == defaultFont.italic{
                resultOfChecking = 1
            } else if nowFont == defaultFont.bold {
                resultOfChecking = 2
            } else if nowFont == defaultFont.boldItalic {
                resultOfChecking = 3
            }
            /// ↑   Сравниваем различные возможные комбинации шрифтов с полученным шрифтом
            
            switch resultOfChecking {
            case 0:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.bold, range: selectedRange)
            case 1:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.boldItalic, range: selectedRange)
            case 2:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont, range: selectedRange)
            case 3:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.italic, range: selectedRange)
            default:
                print("Что-то пошло не так с didBoldButtonTapped")
                noteTextView.textStorage.addAttribute(.font, value: defaultFont, range: selectedRange)
            }
            /// ↑   В зависимости от шрифта ставим другой шрифт
        }
    }
    
    func didItalicButtonTapped() {
        guard let fontSize = noteTextView.font?.pointSize else { return }
        
        let textStorage = noteTextView.textStorage
        let selectedLocation = noteTextView.selectedRange.location
        let selectedRange = noteTextView.selectedRange
        let defaultFont = UIFont.systemFont(ofSize: fontSize)
        
        // Если выделенный диапазон равен нулю и кнопка bold не нажата, то печатем italic, а также при нажатиях переключаемся между обычным и italic
        if selectedRange.length == 0 && !isBoldButtonTappedWithoutSelection {
            if !isItalicButtonTappedWithoutSelection {
                isItalicButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.italic
            } else {
                isItalicButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont
            }
            // Если кнопка bold нажата, то печатаем bold-italic, переключаемся между bold-italic и bold
        } else if selectedRange.length == 0 && isBoldButtonTappedWithoutSelection {
            if !isItalicButtonTappedWithoutSelection {
                isItalicButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.boldItalic
            } else {
                isItalicButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont.bold
            }
        }
        
        // Если что-то выделено
        if selectedRange.length > 0 {
            guard let nowFont = textStorage.attribute(.font, at: selectedLocation, effectiveRange: nil) as? UIFont else { return }
            /// ↑   Получаем UIFont выделенного текста
            
            var resultOfChecking: Int = -1
            /// ↑   0 - default, 1 - italic, 2 - bold, 3 - boldItalic
            
            if nowFont == defaultFont {
                resultOfChecking = 0
            } else if nowFont == defaultFont.italic{
                resultOfChecking = 1
            } else if nowFont == defaultFont.bold {
                resultOfChecking = 2
            } else if nowFont == defaultFont.boldItalic {
                resultOfChecking = 3
            }
            /// ↑   Сравниваем различные возможные комбинации шрифтов с полученным шрифтом
            
            switch resultOfChecking {
            case 0:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.italic, range: selectedRange)
            case 1:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont, range: selectedRange)
            case 2:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.boldItalic, range: selectedRange)
            case 3:
                noteTextView.textStorage.addAttribute(.font, value: defaultFont.bold, range: selectedRange)
            default:
                print("Что-то пошло не так с didItalicButtonTapped")
                noteTextView.textStorage.addAttribute(.font, value: defaultFont, range: selectedRange)
            }
            /// ↑   В зависимости от шрифта ставим другой шрифт
        }
    }
    
    
    // MARK: - Private functions
    
    @objc private func didDoneTapped() {
        view.endEditing(true)
    }
    
    // Передаем текст в наше замыкание и, если была нажата клавиша жирности или italic, убираем их эффект (false), чтобы в последующие разы редактирования текст не продолжался печататься жирным
    private func returnText() {
        noteTextView.attributedText.length == 0 ? completion?(NSAttributedString(string: "")) : completion?(noteTextView.attributedText)
        isBoldButtonTappedWithoutSelection = false
        isItalicButtonTappedWithoutSelection = false
    }
}


