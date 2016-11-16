import Foundation
import UIKit

class NotesManager {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userDefaultKey = "notes"

    func search(query: String) -> [Note] {
        let notes = get()
        if query.isEmpty {
            return notes
        }
        
        var matchNotes: [Note] = []
        for note in notes {
            if note.memo.localizedCaseInsensitiveContainsString(query) {
                matchNotes.append(note)
            }
        }
        
        return matchNotes
    }
    
    func save(note: Note) {
        var saveNotes: Dictionary<String, AnyObject> = [:]
        
        if let resultNotes = userDefaults.objectForKey(userDefaultKey) as? Dictionary<String, AnyObject> {
            saveNotes = resultNotes
        }
        
        var addNotes: Dictionary<String, AnyObject> = [:]
        addNotes["text"] = note.memo
        addNotes["image"] = UIImageJPEGRepresentation(note.image, 0.25)
        saveNotes[note.id] = addNotes
        
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
    
    private func get() -> [Note] {
        
        var saveNotes: Dictionary<String, AnyObject> = [:]
        
        if let resultNotes = userDefaults.objectForKey(userDefaultKey) as? Dictionary<String, AnyObject> {
            saveNotes = resultNotes
        }
        
        return convertNotes(saveNotes)
    }
    
    private func allDelete() {
        userDefaults.removeObjectForKey(userDefaultKey)
    }
    
    private func convertNotes(dictionary: Dictionary<String, AnyObject>) -> [Note] {
        var notes: [Note] = []
        
        let sortedNotes = dictionary.sort { $0.0 > $1.0 }
        
        for (key, value) in sortedNotes {
            
            var note = Note()
            note.id = key
            if let memo = value["text"] as? String {
                note.memo = memo
            }
            if let imageData = value["image"] as? NSData,
                let image = UIImage(data: imageData) {
                note.image = image
            }
            notes.append(note)
        }

        return notes
    }
}
