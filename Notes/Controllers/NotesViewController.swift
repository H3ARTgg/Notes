import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var noNotesLabel: UILabel!
    
    private var tapped: Bool = false
    private var notes: [Note] = [
        Note(
            title: "Новая заметка",
            text: "Текст")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        showNoNotesLabelAndHideTableViewOrNot()
        
    }
    
    // MARK: - IBActions
    
    @IBAction private func didTapNewNote() {
        guard let viewController = UIStoryboard(name: Constants.storyboardID, bundle: .main).instantiateViewController(withIdentifier: Constants.newNoteVCID) as? NewNoteViewController else { return }
        
        viewController.title = "Новая заметка"
        viewController.completion = { [weak self] noteTitle, noteText in
            guard let self = self else { return }
            
            self.navigationController?.popToRootViewController(animated: true)
            self.notes.append(Note(title: noteTitle, text: noteText))
            self.tableView.reloadData()
            self.showNoNotesLabelAndHideTableViewOrNot()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Private functions
    
    private func showNoNotesLabelAndHideTableViewOrNot() {
        if notes.count == 0 {
            noNotesLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotesLabel.isHidden = true
            tableView.isHidden = false
            
        }
    }
}

// MARK: - Extension

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    @IBAction private func didTapEditButton() {
//        tapped = true
//        let button = UIButton()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewController = UIStoryboard(name: Constants.storyboardID, bundle: .main).instantiateViewController(withIdentifier: Constants.noteVCID) as? NoteViewController else { return }
        
        viewController.noteTitle = notes[indexPath.row].title
        viewController.noteText = notes[indexPath.row].text
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.notes.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
}
