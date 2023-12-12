//
//  checkInputs.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/11/23.
//

import Foundation

func isEmptyInput(_ input: String) -> Bool {
    return input.trimmingCharacters(in: .whitespaces).isEmpty
}

func isValidEmail(_ email: String) -> Bool {
    // 此处使用简单的正则表达式来校验邮箱格式
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
    return emailPred.evaluate(with: email)
}

func isValidPassword(_ password: String) -> Bool {
    // 密码至少8位，且包含字母、数字和特殊符号
    let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$&*]).{8,}$"
    let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
    return passwordPred.evaluate(with: password)
}


