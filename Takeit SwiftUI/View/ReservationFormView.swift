import SwiftUI

struct ReservationFormView: View {
    @Binding var reservationDate: String
    @Binding var reservationTime: String
    @Binding var reservationPlace: String
    @Binding var reservationDetails: String
    @Binding var reservationNotes: String
    
    @State private var selectedDate = Date()
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    @State private var meetingPlace = ""
    @State private var placeDetails = ""
    @State private var additionalNotes = ""
    
    
    
    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("予約希望日")) {
                    DatePicker("予約希望日", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("待ち合わせ時間")) {
                    Picker("時間", selection: $selectedHour) {
                        ForEach(hours, id: \.self) { Text("\($0)時") }
                    }
                    Picker("分", selection: $selectedMinute) {
                        ForEach(minutes, id: \.self) { Text("\($0)分") }
                    }
                }
                
                Section(header: Text("待ち合わせ場所")) {
                    TextField("待ち合わせ場所", text: $meetingPlace)
                }
                
                Section(header: Text("待ち合わせ場所(詳細)")) {
                    TextField("詳細", text: $placeDetails)
                }
                
                Section(header: Text("通訳内容")) {
                    TextField("通訳内容", text: $additionalNotes)
                }
                
                HStack {
                    Spacer()
                    Button("予約内容を保存") {
                        reservationDate = "予約希望日: \(selectedDate.formatted())"
                        reservationTime = "待ち合わせ時間: \(selectedHour)時\(selectedMinute)分"
                        reservationPlace = "待ち合わせ場所: \(meetingPlace) "
                        reservationDetails = "待ち合わせ場所(詳細): \(placeDetails) "
                        reservationNotes = "通訳内容: \(additionalNotes) "
                        
                        dismiss()
                        
                    }
                    Spacer()
                }
            }
            .padding()
            .cornerRadius(8)
            Spacer()
            
            
                .navigationTitle("予約画面")
        }
    }
}
