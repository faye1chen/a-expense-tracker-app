//
//  Categories.swift
//  GoodbyeMoney
//
//

import SwiftUI
import RealmSwift

struct Categories: View {
    
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var invalidDataAlertShowing = false
    @State private var newCategoryName: String = ""
    @State private var newCategoryColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    @ObservedResults(Category.self, filter: User.userIdPredicate) var categories
    @ObservedResults(Expense.self, filter: User.userIdPredicate) var expenses
    
    @State private var showAlert = false
    @State private var alertMsg = ""
    
    
    func handleAddCategory() {
        // TODO: 输入校验
        if newCategoryName.count > 0 {
            $categories.append(Category(
                name: newCategoryName,
                color: newCategoryColor
            ))
        } else {
            invalidDataAlertShowing = true
        }
    }
    
    func handleDelete(at offsets: IndexSet) {
        for index in offsets {
            let categoryToDelete = categories[index]
            for expense in expenses {
                if expense.category == categoryToDelete {
                    showAlert = true
                    alertMsg = "Still in use."
                    return
                }
            }
            
            $categories.remove(atOffsets: offsets)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(categories, id: \._id) { category in
                    HStack {
                        Circle()
                            .frame(width: 12)
                            .foregroundColor(category.color)
                        Text(category.name)
                    }
                }
                .onDelete(perform: handleDelete)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                ColorPicker("", selection: $newCategoryColor, supportsOpacity: false)
                    .labelsHidden()
                    .accessibilityLabel("")
                
                ZStack(alignment: .trailing) {
                    
                    TextField("New category", text: $newCategoryName)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.done)
                        .onSubmit {
                            handleAddCategory()
                        }
                    
                    if newCategoryName.count > 0 {
                        Button {
                            newCategoryName = ""
                        } label: {
                            Label("Clear input", systemImage: "xmark.circle.fill")
                                .labelStyle(.iconOnly)
                                .foregroundColor(.gray)
                                .padding(.trailing, 6)
                        }
                    }
                }
                
                Button {
                    handleAddCategory()
                } label: {
                    Label("Submit", systemImage: "paperplane.fill")
                        .labelStyle(.iconOnly)
                        .padding(6)
                }
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
                .alert("Must provide a category name!", isPresented: $invalidDataAlertShowing) {
                    Button("OK", role: .cancel) {
                        invalidDataAlertShowing = false
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationTitle("Categories")
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Info"),
                    message: Text(alertMsg),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }.onAppear(){
//            print((UserManager.shared.currentUser?.userId.stringValue)!)
//            print(categories)
        }
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories()
    }
}
