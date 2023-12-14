//
//  Recurrence.swift
//  GoodbyeMoney
//
//

import Foundation
import RealmSwift

enum Recurrence: String, PersistableEnum, CaseIterable {
    case none = "None"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthy"
    case yearly = "Yearly"
}
