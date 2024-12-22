import SwiftUI

struct HomePageView: View {
    @State private var reservationDate = "予約希望日"
    @State private var reservationTime = "待ち合わせ時間"
    @State private var reservationPlace = "待ち合わせ場所"
    @State private var reservationDetails = "待ち合わせ場所(詳細)"
    @State private var reservationNotes = "通訳内容"
    @State private var showReservationForm = false

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 10) {
                Button(action: {
                    showReservationForm.toggle()
                }) {
                    Text("予約画面")
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }

                Button(action: {}) {
                    Text("予約履歴")
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                    
                }
            }
            .padding([.leading, .trailing], 10)

            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 8) {
                    Text("今週の予約")
                        .font(.headline)
                        .padding(.top)
                    Text(reservationDate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservationTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservationPlace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservationDetails)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservationNotes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(width: geometry.size.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
            .frame(height: 200)
            .padding([.leading, .trailing], 10)

            List {
                Text("2025/12/22")
                Text("2")
            }
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(reservationDate: $reservationDate, reservationTime: $reservationTime, reservationPlace: $reservationPlace, reservationDetails: $reservationDetails, reservationNotes: $reservationNotes)
        }
    }
}
