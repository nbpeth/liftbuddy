import RealmSwift
import Foundation

class RealmManager {
    let realm = try! Realm()
    static let shared = RealmManager()
    
    func beginWrite(){
        realm.beginWrite()
    }
    
    func saveChanges(){
        try! realm.commitWrite()
    }
    
    func discardChanges(){
        realm.cancelWrite()
    }
}
