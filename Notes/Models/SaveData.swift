import Foundation

class SaveData: SaveDataProtocol {
    private enum Key: String {
        case notes
    }
    
    private let userDefaults = UserDefaults.standard
    private(set) var notes: [Note] {
        get {
            guard let data = userDefaults.data(forKey: Key.notes.rawValue),
                let result = try? PropertyListDecoder().decode([Note].self, from: data) else {
                return .init(arrayLiteral: Note(text: "Новая заметка"))
            }
            
            return result
        }
        
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Key.notes.rawValue)
        }
    }
    
    func store(notes: [Note]) {
        self.notes = notes
    }
}
