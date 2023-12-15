//
//  RealmManager.swift
//  GoodbyeMoney
//
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?

    init() {
        openRealm()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 3, // 更新架构版本
                migrationBlock: { migration, oldSchemaVersion in
                     if oldSchemaVersion < 3 {
                         // 迁移逻辑
                         // 因为这里是添加属性，所以可能不需要写具体的迁移代码
                     }
                })
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm", error)
        }
    }
    
    func deleteAllData() {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.deleteAll()
                    
                    print("Delete Successfully.")
                }
            } catch {
                print("Error deleting all data: \(error)")
            }
        }
        
        
    }
    
    func getCateByCateName(_ categoryName : String) -> Category? {
        guard let localRealm = localRealm else {
            print("Realm not initialized")
            return nil
        }
        
        let cate = localRealm.objects(Category.self).filter(User.userIdPredicate).filter("name == %@", categoryName)
        
        return cate.first
    }
    
    func getCateByCateId(_ selectedCategoryId : ObjectId) -> Category? {
        guard let localRealm = localRealm else {
            print("Realm not initialized")
            return nil
        }
        
        let cate = localRealm.objects(Category.self).filter("_id == %@", selectedCategoryId)
        
        return cate.first
    }
    
    func signUpNewUser(_ user: User) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(user)
                    
                    print("User submitted to Realm!", user)
                }
            } catch {
                print("Error submitting user to Realm: \(error)")
            }
        }
    }
    
    func signInUser(_ email : String, _ password : String) -> User? {
        guard let localRealm = localRealm else {
            print("Realm not initialized")
            return nil
        }
        
        let users = localRealm.objects(User.self).filter("email == %@", email)
        if let user = users.first {
            if !user.validatePassword(password) {
                print("Password error")
                return nil
            } else {
                return user
            }
        } else {
            print("No user found with the given email")
            return nil
        }
    }
    
    func getUserByEmail(_ email: String) -> User? {
        guard let localRealm = localRealm else {
            print("Realm not initialized")
            return nil
        }
        
        let users = localRealm.objects(User.self).filter("email == %@", email)
        return users.first
    }
}
