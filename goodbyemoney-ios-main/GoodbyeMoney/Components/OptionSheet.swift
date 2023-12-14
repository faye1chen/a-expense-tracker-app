//
//  OptionSheet.swift
//  GoodbyeMoney
//
//  Created by 李明霞 on 12/14/23.
//

import SwiftUI

struct OptionSheet: View {
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            SecondaryButton(title: "Edit", onPressed: {
                onEdit()
            })
            
            SecondaryButton(title: "Delete", onPressed: {
                onDelete()
            })
            Spacer()
        }
    }
}
