//
//  Add.swift
//  GoodbyeMoney
//
//

import SwiftUI
import RealmSwift
import AVKit

struct Add: View {
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var selectedCategory: Category = Category(name: "Create a category first", color: Color.clear)
    
    @State private var selectedCategoryId: ObjectId = ObjectId()

    @State private var amount = ""
    @State private var recurrence = Recurrence.none
    @State private var date = Date()
    @State private var note = ""
    
    @State private var showAlert = false
    @State private var alertMsg = ""
    
    @ObservedResults(Category.self, filter: User.userIdPredicate) var categories
    @ObservedResults(Expense.self, filter: User.userIdPredicate) var expenses
    
    func onAppear() {
        if categories.count > 0 {
            self.selectedCategory = categories[0]
            self.selectedCategoryId = selectedCategory._id
        }
    }
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let max = Date()
        return min...max
    }
    
    func checkInput() -> Bool {
        guard !isEmptyInput(self.amount) && !isEmptyInput(self.note) else {
            alertMsg = "Empty Input"
            self.showAlert = true
            return false
        }
        
        guard let amountValue = Double(self.amount), amountValue > 0 else {
            alertMsg = "Invalid Amount"
            self.showAlert = true
            return false
        }
    
        guard !self.note.isEmpty && self.selectedCategory.name != "Create a category first" else {
            alertMsg = "Invalid Note or Category"
            self.showAlert = true
            return false
        }
        
        return true
    }
    
    func handleCreate() {
        guard checkInput() else {
            return
        }
        
        $expenses.append(Expense(amount: Double(self.amount)!, category: realmManager.getCateByCateId(selectedCategoryId)!, date: self.date, note: self.note, recurrence: self.recurrence))
        
        print(expenses)
        
        alertMsg = "Successfully"
        self.showAlert = true

        self.amount = ""
        self.recurrence = Recurrence.none
        self.date = Date()
        self.note = ""
        
        hideKeyboard()
    }

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("Note")
                        Spacer()
                        TextField("Note", text: $note)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", text: $amount)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                            .keyboardType(.numberPad)
                    }
                    
//                    HStack {
//                        Text("Recurrence")
//                        Spacer()
//                        Picker(selection: $recurrence, label: Text(""), content: {
//                            Text("None").tag(Recurrence.none)
//                            Text("Daily").tag(Recurrence.daily)
//                            Text("Weekly").tag(Recurrence.weekly)
//                            Text("Monthly").tag(Recurrence.monthly)
//                            Text("Yearly").tag(Recurrence.yearly)
//                        })
//                    }
                    
                    HStack {
                        Text("Date")
                        Spacer()
                        DatePicker(
                            selection: $date,
                            in: dateClosedRange,
                            displayedComponents: .date,
                            label: { Text("") }
                        )
                    }
                    
                    
                    
                    HStack {
                        Text("Category")
                        Spacer()
                        Picker(selection: $selectedCategoryId, label: Text(""), content: {
                                if categories.count > 0 {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category.name).tag(category._id)
                                    }
                                } else {
                                    Text(selectedCategory.name).tag(selectedCategory._id)
                                }
                            
                        })
                    }
                }
                .scrollDisabled(true)
                .frame(height: 275)
                
                Button {
                    handleCreate()
                } label: {
                    Label("Submit expense", systemImage: "plus")
                        .labelStyle(.titleOnly)
                        .padding(.horizontal, 44)
                        .padding(.vertical, 12)
                }
                .foregroundColor(.white)
                .background(.blue)
                .cornerRadius(10)
                
                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle("Add")
            
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Info"),
                    message: Text(alertMsg),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            onAppear()
        }
    }
}

struct Add_Previews: PreviewProvider {
    static var previews: some View {
        Add()
    }
}
