import RealmSwift
import Foundation

class RealmManager {
    let realm = try! Realm()
    static let shared = RealmManager()
    
    //RealmManager.shared.realm.isInWriteTransaction
    
    func beginWrite(){
        realm.beginWrite()
    }
    
    func saveChanges(){
        try! realm.commitWrite()
    }
    
    func discardChanges(){
        if self.realm.isInWriteTransaction {
            realm.cancelWrite()
        }
    }
}
