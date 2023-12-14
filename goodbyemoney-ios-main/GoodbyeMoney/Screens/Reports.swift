//
//  Reports.swift
//  GoodbyeMoney
//
//

import SwiftUI

struct Reports: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var period: Period = Period.week
    @State private var tabViewSelection = 0
    @State private var pagesRange = 0..<53
    @State private var showSaveAlert = false

    func setPagesRange() {
        switch self.period {
        case .day:
            break
        case .week:
            pagesRange = 0..<53
        case .month:
            pagesRange = 0..<12
        case .year:
            pagesRange = 0..<1
        }
    }
    
    
    func captureAndSaveReport() {
        guard let window = UIApplication.shared.windows.first else { return }
        let headerHeight: CGFloat = 100  // 需要截取的头部高度
        let footerHeight: CGFloat = 350  // 需要截取的尾部高度
        let captureHeight = window.bounds.height - headerHeight - footerHeight

        let captureRect = CGRect(x: 0, y: headerHeight, width: window.bounds.width, height: captureHeight)

//        let captureRect = CGRect(x: 0, y: 0, width: window.bounds.width, height: window.bounds.height - 410)
        guard let capturedImage = CaptureUIView.capture(view: window, rect: captureRect) else { return }
        let imageWithText = capturedImage.addingText("Come and join me!")

        let imageSaver = ImageSaver()
        imageSaver.successHandler = {
            self.showSaveAlert = true
        }
        imageSaver.errorHandler = {
            // 这里处理错误
        }

        UIImageWriteToSavedPhotosAlbum(imageWithText, imageSaver, #selector(ImageSaver.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TabView(selection: $tabViewSelection) {
                    ForEach(pagesRange, id: \.self) { index in
                        VStack {
                            PeriodChart(period: period, periodIndex: index)
                        }
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .id(pagesRange)
                
//                // 捕获和保存报告的按钮
//                Button("Capture Report") {
//                    captureAndSaveReport()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .cornerRadius(10)
            }
            .padding(.top, 16)
            .navigationTitle("Reports")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // 新增的 "Capture Report" 按钮，使用 Label
                    Button(action: captureAndSaveReport) {
                        Label("Capture Report", systemImage: "camera") // 使用您选择的图标
                    }
                    Menu {
                        Picker(selection: $period, label: Text("Period"), content: {
                            Text(Period.week.rawValue).tag(Period.week)
                            Text(Period.month.rawValue).tag(Period.month)
                            Text(Period.year.rawValue).tag(Period.year)
                        })
                    } label: {
                        Label("Period", systemImage: "calendar")
                    }
                }
            }
        }
        .alert(isPresented: $showSaveAlert) {
            Alert(title: Text("Save successfully"), message: Text("Your report has been saved to the photo album."), dismissButton: .default(Text("OK")))
        }
        .onChange(of: period) { _ in
            self.tabViewSelection = 0
            setPagesRange()

        }
    }
}

//struct Reports_Previews: PreviewProvider {
//    static var previews: some View {
//        Reports()
//    }
//}

// 辅助类，用于处理图片保存回调
class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: (() -> Void)?

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            successHandler?()
        } else {
            errorHandler?()
        }
    }
}
