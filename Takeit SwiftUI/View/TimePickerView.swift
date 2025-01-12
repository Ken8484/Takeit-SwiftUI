import SwiftUI

struct TimePickerView: View {
    @Binding var reservationTime: String
    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }

    var body: some View {
        VStack {
            Picker("時間", selection: Binding(
                get: {
                    Int(reservationTime.split(separator: "時").first ?? "9") ?? 9
                },
                set: { newHour in
                    let currentMinute = Int(reservationTime.split(separator: "時").last?.split(separator: "分").first ?? "0") ?? 0
                    reservationTime = "\(newHour)時\(currentMinute)分"
                }
            )) {
                ForEach(hours, id: \.self) { hour in
                    Text("\(hour)時").tag(hour)
                }
            }

            Picker("分", selection: Binding(
                get: {
                    Int(reservationTime.split(separator: "時").last?.split(separator: "分").first ?? "0") ?? 0
                },
                set: { newMinute in
                    let currentHour = Int(reservationTime.split(separator: "時").first ?? "9") ?? 9
                    reservationTime = "\(currentHour)時\(newMinute)分"
                }
            )) {
                ForEach(minutes, id: \.self) { minute in
                    Text("\(minute)分").tag(minute)
                }
            }
        }
    }
}
