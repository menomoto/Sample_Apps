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
        
        var notes: [Note] = []
        
        let sortedNotes = saveNotes.sort { $0.0 > $1.0 }
        
        for (key, value) in sortedNotes {
            
            var note = Note()
            note.id = key
            note.memo = value
            
            notes.append(note)
        }
        
        return notes
    }
    
    func save(note: Note) {
        var saveNotes: Dictionary<String, String> = [:]
        
        if let resultNotes = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            saveNotes = resultNotes
        }
        
        var id = note.id
        if note.id.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: NSLocaleLanguageCode)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            id = dateFormatter.stringFromDate(NSDate())
        }
        saveNotes[id] = note.memo
        
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
    
    func allDelete() {
        userDefaults.removeObjectForKey(userDefaultKey)
    }
}
