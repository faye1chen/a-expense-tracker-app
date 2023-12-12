//
//  RealmManager.swift
//  GoodbyeMoney
//
//  Created by Lazar Nikolov on 2022-09-23.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published var expenses: [Expense] = []
    @Published var categories: [Category] = []

    init() {
        openRealm()
        
//        loadExpenses()
//        loadCategories()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 2, // 更新架构版本
                migrationBlock: { migration, oldSchemaVersion in
                     if oldSchemaVersion < 2 {
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
    
    func loadExpenses() {
        if let localRealm = localRealm {
            let allExpenses = localRealm.objects(Expense.self).sorted(byKeyPath: "date")
            
            expenses = []
            
            allExpenses.forEach { expense in
                expenses.append(expense)
            }
        }
    }
    
    func submitExpense(_ expense: Expense) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(expense)
                    
                    loadExpenses()
                    print("Expense submitted to Realm!", expense)
                }
            } catch {
                print("Error submitting expense to Realm: \(error)")
            }
        }
    }
    
    func loadCategories() {
        print(UserManager.shared.currentUser!)
        
        if let localRealm = localRealm, let userId = UserManager.shared.currentUser?.userId.stringValue {
            print(userId)
            let userCategories = localRealm.objects(Category.self).filter("userId == %@", userId)

            categories = Array(userCategories)
        }
    }
    
    func submitCategory(_ category: Category) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.add(category)
                    
                    loadCategories()
                    print("Category submitted to Realm!", category)
                }
            } catch {
                print("Error submitting category to Realm: \(error)")
            }
        }
    }
    
    func deleteCategory(category: Category) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    localRealm.delete(category)
                    
                    loadCategories()
                    print("Category deleted from Realm!", category)
                }
            } catch {
                print("Error deleting category to Realm: \(error)")
            }
        }
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
