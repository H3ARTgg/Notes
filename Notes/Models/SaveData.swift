import Foundation
import UIKit

class SaveData: SaveDataProtocol {
    private enum Key: String {
        case notes
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var notes: [Note] {
        get {
            guard let data = userDefaults.data(forKey: Key.notes.rawValue),
                let result = try? PropertyListDecoder().decode([Note].self, from: data) else {
                let attributedString = AttributedString("Новая заметка", attributes:
                    AttributeContainer([
                        .foregroundColor : UIColor(named: "Black-White") ?? .black,
                        .font : UIFont.systemFont(ofSize: 20)
                        ]))
                
                return .init(arrayLiteral: Note(text: attributedString))
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
    /// ↑   Для сохранения данных
}
