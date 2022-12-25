import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noNotesLabel: UILabel!
    private var saveData: SaveDataProtocol?
    private var isEditButtonDidTapped: Bool = false
    private var rowsWhichAreChecked = [IndexPath]()
    private var notes: [Note] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        
        saveData = SaveData()
        if let notes = saveData?.notes {
            self.notes = notes
        }
        
        showNoNotesLabelAndHideTableViewOrNot()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData?.store(notes: notes)
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapNewNote() {
        guard let viewController = UIStoryboard(name: Constants.storyboardID, bundle: .main).instantiateViewController(withIdentifier: Constants.noteVCID) as? NoteViewController else { return }

        viewController.title = "Новая заметка"
        viewController.newNote = true
        viewController.completion = { [weak self] text in
            guard let self = self else { return }

            if text.isEmpty {
                self.navigationController?.popToRootViewController(animated: true)
                self.showNoNotesLabelAndHideTableViewOrNot()
            } else {
                self.navigationController?.popToRootViewController(animated: true)
                self.notes.append(Note(text: text))
                self.saveData?.store(notes: self.notes)
                self.showNoNotesLabelAndHideTableViewOrNot()
            }
        }

        navigationController?.pushViewController(viewController, animated: true)
        /// ↑   При нажатии кнопки "+" показывает NewNoteViewController (контроллер создания заметки). Показывает контроллер через push метода NavigationController. Если нет текста, то не создает новую заметку
    }
    
    @IBAction private func didTapEditButton() {
        if isEditButtonDidTapped == false {
            isEditButtonDidTapped = true
            
            /// ↑   По умолчанию isEditButtonDidTapped = false, при нажатии станет true и затем снова при нажатии будет false для закрытия "режима редактирования"
            navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                title: "Удалить",
                style: .done,
                target: self,
                action: #selector(deleteButtonWhileEditTapped))
            /// ↑   Создаем кнопку "Удалить" вместо "+"
            
            let nib = UINib(nibName: Constants.customCellNibName, bundle: .main)
            tableView.register(nib, forCellReuseIdentifier: Constants.customCellID)
            /// ↑   Регистрируем XIB файл с кнопкой
        } else {
            isEditButtonDidTapped = false
            rowsWhichAreChecked.removeAll()
            
            navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapNewNote))
            /// ↑   Убираем все выбранные элементы из специализированного массива для этого и возвращаем кнопку "Добавить"
        }
    
        tableView.reloadData()
    }
    
    // MARK: - Private functions
    
    // Нажатие кнопки "Удалить" для селектора из функции didTapEditButton
    @objc private func deleteButtonWhileEditTapped() {
        if !rowsWhichAreChecked.isEmpty {
            for path in rowsWhichAreChecked {
                notes.remove(at: path.row)
                notes.insert(Note(text: ""), at: path.row)
            }
            /// ↑   Если в массиве есть выбранные ячейки, то заменяем наши выбранные индексы в notes на пустой текст.
            /// Зачем? Потому что если выбранные элементы имеют индекс 1, 3 и 5 из rowsWhichAreChecked (из 5 элементов в notes), то при удалении из notes значения под индексом 1 - notes индексы съедут до 4. Далее мы удаляем "3" индекс и в notes это будет уже не то значение под индексом "3", а то, что выше
            
            for _ in notes {
                let note = Note(text: "")
                if let index = notes.firstIndex(where: {$0.text == note.text }) {
                    notes.remove(at: index)
                }
                /// ↑   Чистим все одинаковые пустые поля
            }
            
            didTapEditButton()
            showNoNotesLabelAndHideTableViewOrNot()
            saveData?.store(notes: notes)
            /// ↑   Вызываем didTapEditButton чтобы переключить значение isEditButtonDidTapped и вернуть прежний вид правой кнопке в NavigationController. Остальное говорит само за себя
        } else {
            didTapEditButton()
            showNoNotesLabelAndHideTableViewOrNot()
            saveData?.store(notes: notes)
            /// ↑   Если нет "выбранных ячеек", то возращаем прежний вид
            
        }
    }
    
    private func showNoNotesLabelAndHideTableViewOrNot() {
        if notes.count == 0 {
            noNotesLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotesLabel.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
        /// ↑   Показывает лэйбл "Нет заметок" и прячет tableView
    }
}

// MARK: - Extension

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Если кнопка "Edit" нажата (true)
        if isEditButtonDidTapped {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customCellID, for: indexPath) as? NoteCellWithButton else { return UITableViewCell() }
            
            cell.cellLabel.text = notes[indexPath.row].text

            if !rowsWhichAreChecked.contains(indexPath) {
                cell.cellButton.isChecked = false
                }
            /// ↑   Если были выбраны элементы и кнопка "Edit" нажата (для отмены процесса), то убирает визуальный вид "выбранных" кнопок при повторном нажатии "Edit"
            
            return cell
            
        } else {
            
            // В случае, если кнопка "Edit" не нажата (false)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? NoteCell else { return UITableViewCell() }
            cell.cellLabel.text = notes[indexPath.row].text
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Если кнопка "Edit" нажата (true)
        if isEditButtonDidTapped {
            guard let cell = tableView.cellForRow(at: indexPath) as? NoteCellWithButton else { return }
            
            if rowsWhichAreChecked.contains(indexPath) == false {
                cell.cellButton.isChecked = true
                rowsWhichAreChecked.append(indexPath)
                /// ↑   Если indexPath в массиве "выбранных" нет (при нажатии на ячейку), то меняет изображение ячейки на "выбранную" и добавляет в массив "выбранных"
            } else {
                cell.cellButton.isChecked = false
                if let checkedItemIndex = rowsWhichAreChecked.firstIndex(of: indexPath) {
                    rowsWhichAreChecked.remove(at: checkedItemIndex)
                }
                /// ↑   Если же ячейка есть в массиве выбранных, то меняем изображение на "не выбрано" и получаем первый индекс по indexPath, убирая из массива "выбранных" по индексу
            }
        // Если кнопка "Edit" не нажата (false)
        } else {
            guard let viewController = UIStoryboard(name: Constants.storyboardID, bundle: .main).instantiateViewController(withIdentifier: Constants.noteVCID) as? NoteViewController else { return }
            
            viewController.noteText = notes[indexPath.row].text
            viewController.completion = { [weak self] text in
                guard let self = self else { return }
                
                if text.isEmpty {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.notes.remove(at: indexPath.row)
                    self.showNoNotesLabelAndHideTableViewOrNot()
                    self.saveData?.store(notes: self.notes)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.notes.remove(at: indexPath.row)
                    self.notes.insert(Note(text: text), at: indexPath.row)
                    self.showNoNotesLabelAndHideTableViewOrNot()
                    self.saveData?.store(notes: self.notes)
                }
            }
            navigationController?.pushViewController(viewController, animated: true)
            /// ↑   Показывает NoteViewController (контроллер просмотра и изменения заметки). Показывает контроллер через push метода NavigationController. Если нет текста (при изменении), то заметка удаляется, иначе переписывается каждый раз
        }
    }
    
    // Если "Edit" нажата, то нельзя удалять через свайп
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditButtonDidTapped ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !isEditButtonDidTapped {
            if editingStyle == .delete {
                self.notes.remove(at: indexPath.row)
                showNoNotesLabelAndHideTableViewOrNot()
                saveData?.store(notes: notes)
                /// ↑   При удалении через свайп
            }
        }
    }
}
