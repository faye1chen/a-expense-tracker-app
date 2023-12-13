//
//  KeychainManager.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/13/23.
//

import Security
import Foundation

class KeychainManager {
    static let serviceName = "MonTrack"

    static func savePIN(pin: String, for account: String) -> Bool {
        guard let pinData = pin.data(using: .utf8) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: pinData
        ]

        // Add the new item to the keychain.
        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecSuccess {
            return true
        } else {
            // Check the error.
            // errSecDuplicateItem indicates an item already exists with the same service and account.
            if status == errSecDuplicateItem {
                // Item already exists, update it.
                let updateQuery: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrService as String: serviceName,
                    kSecAttrAccount as String: account
                ]
                let updateAttributes: [String: Any] = [
                    kSecValueData as String: pinData
                ]
                let updateStatus = SecItemUpdate(updateQuery as CFDictionary, updateAttributes as CFDictionary)
                return updateStatus == errSecSuccess
            }
            return false
        }
    }
    
    static func getPIN(for account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceName,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let pin = String(data: retrievedData, encoding: .utf8) {
                return pin
            }
        }
        return nil
    }
}

