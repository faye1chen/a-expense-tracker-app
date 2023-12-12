//
//  User.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/11/23.
//

import Foundation
import RealmSwift
import CommonCrypto

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var userId: ObjectId
    @Persisted var email: String
    @Persisted var hashedPassword: String
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.setPassword(password)
    }

    func setPassword(_ password: String) {
        hashedPassword = sha256(password)
    }

    private func sha256(_ string: String) -> String {
        if let data = string.data(using: .utf8) {
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
            }
            return Data(hash).map { String(format: "%02x", $0) }.joined()
        }
        return ""
    }

    func validatePassword(_ password: String) -> Bool {
        return sha256(password) == hashedPassword
    }
}

class UserManager: ObservableObject {
    @Published var currentUser: User?
}
