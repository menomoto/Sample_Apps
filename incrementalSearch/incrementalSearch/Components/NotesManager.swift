import Foundation
import UIKit

class NotesManager {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userDefaultKey = "notes"

    func get() -> [Note] {

        var saveNotes: Dictionary<String, String> = [:]
        
        if let resultNotes = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            saveNotes = resultNotes
        }
        
        return convertNotes(saveNotes)
    }
    
    func save(note: Note) {
        var saveNotes: Dictionary<String, String> = [:]
        
        if let resultNotes = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            saveNotes = resultNotes
        }
        
        saveNotes[note.id] = note.memo
        
        userDefaults.setObject(
            saveNotes,
            forKey: userDefaultKey
        )
        
    }
    
    func delete(id: String) {
        let notes = get()
        allDelete()
        for note in notes {
            if note.id != id {
                save(note)
            }
        }
    }
    
    private func allDelete() {
        userDefaults.removeObjectForKey(userDefaultKey)
    }
    
    private func convertNotes(dictionary: Dictionary<String, String>) -> [Note] {
        var notes: [Note] = []
        
        let sortedNotes = dictionary.sort { $0.0 > $1.0 }
        
        for (key, value) in sortedNotes {
            
            var note = Note()
            note.id = key
            note.memo = value
            
            notes.append(note)
        }

        return notes
    }
}
