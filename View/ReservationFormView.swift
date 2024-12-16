import SwiftUI

struct ReservationFormView: View {
    @Binding var reservation1: String
    @Binding var reservation2: String
    @Binding var reservation3: String
    @Binding var reservation4: String
    @Binding var reservation5: String
    @State private var reservationDate = Date()
    @State private var selectedTimeHour = 9
    @State private var selectedTimeMinute = 0
    @State private var location = ""
    @State private var locationdetails = ""
    @State private var interpreter = ""
    @State private var bikou = ""
    @State private var reservationContent = ""
    

    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("予約希望日")) {
                    DatePicker("予約希望日", selection: $reservationDate, displayedComponents: .date)
                }

                Section(header: Text("待ち合わせ時間")) {
                    Picker("時間", selection: $selectedTimeHour) {
                        ForEach(hours, id: \.self) { Text("\($0)時") }
                    }
                    Picker("分", selection: $selectedTimeMinute) {
                        ForEach(minutes, id: \.self) { Text("\($0)分") }
                    }
                }

                Section(header: Text("待ち合わせ場所")) {
                    TextField("待ち合わせ場所", text: $location)
                }

                Section(header: Text("待ち合わせ場所(詳細)")) {
                    TextField("詳細", text: $locationdetails)
                }

                Section(header: Text("通訳内容")) {
                    TextField("通訳内容", text: $reservationContent)
                }

                
                }
                .padding()
                .background(Color.green.opacity(0.3))
                .cornerRadius(8)
            
            Button("予約内容を保存") {
                reservation1 = "予約希望日: \(reservationDate.formatted())"
                reservation2 = "待ち合わせ時間: \(selectedTimeHour)時\(selectedTimeMinute)分"
                reservation3 = "待ち合わせ場所: \(location) "
                reservation4 = "待ち合わせ場所(詳細): \(locationdetails) "
                reservation5 = "通訳内容: \(reservationContent) "
                dismiss()
                
            }
        
            .navigationTitle("予約画面")
        }
    }
}
