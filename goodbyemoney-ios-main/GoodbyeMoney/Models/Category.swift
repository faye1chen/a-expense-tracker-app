//
//  Category.swift
//  GoodbyeMoney
//
//

import SwiftUI
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted private var _color: PersistableColor?
    @Persisted var name: String
    @Persisted var userId: String
    
    var color: Color {
        get {
            if self._color == nil {
                return Color.clear
            }
            return Color(persistedValue: self._color!)
        }
    }
    
    convenience init(name: String, color: Color) {
        self.init()
        
        self.userId = (UserManager.shared.currentUser?.userId.stringValue)!
        self.name = name
        self._color = color.persistableValue
    }
}
