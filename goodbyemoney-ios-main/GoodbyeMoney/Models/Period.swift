//
//  Period.swift
//  GoodbyeMoney
//
//

import Foundation
import RealmSwift

enum Period: String, PersistableEnum, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
