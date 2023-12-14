//
//  Expenses.swift
//  GoodbyeMoney
//
//

import SwiftUI
import RealmSwift

struct Expenses: View {
    @EnvironmentObject var realmManager: RealmManager
    
    @State private var totalExpenses: Double = 0
    @State private var filteredExpenses: [Expense] = []
    @State private var searchQuery = ""
    @State private var timeFilter = Period.week
    
    @State private var selectedExpense: Expense?
    @State private var showingSheet = false
    @State private var showingExpenseDetail = false
    
    @ObservedResults(Expense.self, filter: User.userIdPredicate) var expenses
    
    let columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 96), spacing: 16), count: 3)
    
    func reloadData() {
        print(UserManager.shared.currentUser!.userId)
        print(expenses)
        
        filteredExpenses = filterExpensesInPeriod(period: timeFilter, expenses: Array(expenses), periodIndex: 0).expenses
        
        // 根据searchQuery过滤expenses
        filteredExpenses = searchQuery.isEmpty
            ? filteredExpenses
        : filteredExpenses.filter { $0.category!.name.lowercased().contains(searchQuery.lowercased()) }

        totalExpenses = 0
        totalExpenses = filteredExpenses.reduce(0) { $0 + $1.amount }
    }
    
    func handleEdit() {
        showingSheet.toggle()
        
        $expenses.remove(selectedExpense!)
        showingExpenseDetail.toggle()
    }

    func handleDelete() {
        showingSheet.toggle()
        $expenses.remove(selectedExpense!)
        
        reloadData()
    }

    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Text("Total for:")
                    Picker("", selection: $timeFilter, content: {
                        Text("today").tag(Period.day)
                        Text("this week").tag(Period.week)
                        Text("this month").tag(Period.month)
                        Text("this year").tag(Period.year)
                    })
                    .foregroundColor(.white)
                }
                
                HStack(alignment: .top, spacing: 4) {
                    Text("$")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                    Text("\(totalExpenses.roundTo(2))")
                        .font(.largeTitle)
                }
                
                ExpensesList(expenses: groupExpensesByDate(filteredExpenses), selectedExpense: $selectedExpense, showDetail: $showingSheet)
                    .id(filteredExpenses)
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .navigationTitle("Expenses")
        }
        .searchable(
            text: $searchQuery,
            placement: .automatic,
            prompt: "Search expenses"
        )
        .onChange(of: timeFilter) { newFilter in
            reloadData()
        }
        .onChange(of: searchQuery) { _ in
            reloadData()
        }
        .onAppear {
            reloadData()
        }
        .sheet(isPresented: $showingSheet) {
            OptionSheet(onEdit: handleEdit, onDelete: handleDelete)
                .presentationDetents([.fraction(0.25)])
        }
        .navigationDestination(isPresented: $showingExpenseDetail) {
            ExpenseDetailView(expense: $selectedExpense)
        }
    }
}

struct Expenses_Previews: PreviewProvider {
    static var previews: some View {
        Expenses()
    }
}
