import SwiftUI

struct ReservationFormView: View {
    @Binding var reservation1: String
    @Binding var reservation2: String
    @State private var reservationDate = Date()
    @State private var selectedTimeHour = 9
    @State private var selectedTimeMinute = 0
    @State private var location = ""
    @State private var details = ""
    @State private var interpreter = ""
    @State private var notes = ""
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

                Section(header: Text("詳細")) {
                    TextField("詳細", text: $details)
                }

                Button("予約内容を保存") {
                    reservation1 = "予約希望日: \(reservationDate.formatted())"
                    reservation2 = "予約内容: \(reservationContent)"
                    dismiss()
                }
                .padding()
                .background(Color.green.opacity(0.3))
                .cornerRadius(8)
            }
            .navigationTitle("予約画面")
        }
    }
}
