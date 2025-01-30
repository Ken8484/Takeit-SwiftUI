import SwiftUI

struct TimePickerView: View {
    @Binding var reservationTime: Date
    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }
    
    var body: some View {
        VStack {
            // 時間を選択するPicker
            Picker("時間", selection: Binding(
                get: {
                    Calendar.current.component(.hour, from: reservationTime)
                },
                set: { newHour in
                    updateDate(hour: newHour, minute: Calendar.current.component(.minute, from: reservationTime))
                }
            )) {
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)時").tag(hour)
                }
            }
            
            // 分を選択するPicker
            Picker("分", selection: Binding(
                get: {
                    Calendar.current.component(.minute, from: reservationTime)
                },
                set: { newMinute in
                    updateDate(hour: Calendar.current.component(.hour, from: reservationTime), minute: newMinute)
                }
            )) {
                ForEach(minutes, id: \.self) { minute in
                    Text("\(minute)分").tag(minute)
                }
            }
        }
    }
    
    // 時間と分を更新する関数
    private func updateDate(hour: Int, minute: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: reservationTime)
        components.hour = hour
        components.minute = minute
        reservationTime = Calendar.current.date(from: components) ?? reservationTime
    }
}
