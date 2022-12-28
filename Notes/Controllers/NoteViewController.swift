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
        
        let selectedLocation = noteTextView.selectedRange.location
        let selectedRange = noteTextView.selectedRange
        let defaultFont = UIFont.systemFont(ofSize: fontSize)
        
        // Если выделенный диапазон равен нулю и кнопка italic не нажата, то печатем bold, а также при нажатиях переключаемся между обычным и bold
        if selectedRange.length == 0 && !isItalicButtonTappedWithoutSelection {
            switch isBoldButtonTappedWithoutSelection {
            case false:
                isBoldButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.bold
            case true:
                isBoldButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont
            }
            // Если кнопка italic нажата, то печатаем bold-italic, переключаемся между bold-italic и italic
        } else if selectedRange.length == 0 && isItalicButtonTappedWithoutSelection {
            switch isBoldButtonTappedWithoutSelection {
            case false:
                isBoldButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.boldItalic
            case true:
                isBoldButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont.italic
            }
        }
        
        // Если что-то выделено
        if selectedRange.length > 0 {
            guard let currentFont = noteTextView.textStorage.attribute(.font, at: selectedLocation, effectiveRange: nil) as? UIFont else { return }
            /// ↑   Получаем UIFont выделенного текста
       
            realizationForCurrentFontWithComparingToDefaultFont(
                selectedRange: selectedRange,
                defaultFont: defaultFont,
                currentFont: currentFont,
                equalToDefault: defaultFont.bold,
                equalToItalic: defaultFont.boldItalic,
                equalToBold: defaultFont,
                equalToBoldItalic: defaultFont.italic)
            /// ↑   В зависимости от шрифта ставим другой шрифт
        }
    }
    
    func didItalicButtonTapped() {
        guard let fontSize = noteTextView.font?.pointSize else { return }
        
        let selectedLocation = noteTextView.selectedRange.location
        let selectedRange = noteTextView.selectedRange
        let defaultFont = UIFont.systemFont(ofSize: fontSize)
        
        // Если выделенный диапазон равен нулю и кнопка bold не нажата, то печатем italic, а также при нажатиях переключаемся между обычным и italic
        if selectedRange.length == 0 && !isBoldButtonTappedWithoutSelection {
            switch isItalicButtonTappedWithoutSelection {
            case false:
                isItalicButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.italic
            case true:
                isItalicButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont
            }
            // Если кнопка bold нажата, то печатаем bold-italic, переключаемся между bold-italic и bold
        } else if selectedRange.length == 0 && isBoldButtonTappedWithoutSelection {
            switch isItalicButtonTappedWithoutSelection {
            case false:
                isItalicButtonTappedWithoutSelection = true
                noteTextView.typingAttributes[.font] = defaultFont.boldItalic
            case true:
                isItalicButtonTappedWithoutSelection = false
                noteTextView.typingAttributes[.font] = defaultFont.bold
            }
        }
        
        // Если что-то выделено
        if selectedRange.length > 0 {
            guard let currentFont = noteTextView.textStorage.attribute(.font, at: selectedLocation, effectiveRange: nil) as? UIFont else { return }
            /// ↑   Получаем UIFont выделенного текста
            
            realizationForCurrentFontWithComparingToDefaultFont(
                selectedRange: selectedRange,
                defaultFont: defaultFont,
                currentFont: currentFont,
                equalToDefault: defaultFont.italic,
                equalToItalic: defaultFont,
                equalToBold: defaultFont.boldItalic,
                equalToBoldItalic: defaultFont.bold)
            /// ↑   В зависимости от шрифта ставим другой шрифт
        }
    }
    
    
    // MARK: - Private functions
    
    @objc private func didDoneTapped() {
        view.endEditing(true)
    }
    
    private func realizationForCurrentFontWithComparingToDefaultFont(selectedRange: NSRange, defaultFont: UIFont, currentFont: UIFont, equalToDefault: UIFont, equalToItalic: UIFont, equalToBold: UIFont, equalToBoldItalic: UIFont) {
        switch currentFont {
        case defaultFont:
            noteTextView.textStorage.addAttribute(.font, value: equalToDefault, range: selectedRange)
        case defaultFont.italic:
            noteTextView.textStorage.addAttribute(.font, value: equalToItalic, range: selectedRange)
        case defaultFont.bold:
            noteTextView.textStorage.addAttribute(.font, value: equalToBold, range: selectedRange)
        case defaultFont.boldItalic:
            noteTextView.textStorage.addAttribute(.font, value: equalToBoldItalic, range: selectedRange)
        default:
            print("Что-то пошло не так с didItalicButtonTapped")
            noteTextView.textStorage.addAttribute(.font, value: equalToDefault, range: selectedRange)
        }
        /// ↑   В зависимости от шрифта ставим другой шрифт
    }
    
    // Передаем текст в наше замыкание и, если была нажата клавиша жирности или italic, убираем их эффект (false), чтобы в последующие разы редактирования текст не продолжался печататься жирным
    private func returnText() {
        noteTextView.attributedText.length == 0 ? completion?(NSAttributedString(string: "")) : completion?(noteTextView.attributedText)
        isBoldButtonTappedWithoutSelection = false
        isItalicButtonTappedWithoutSelection = false
    }
}


