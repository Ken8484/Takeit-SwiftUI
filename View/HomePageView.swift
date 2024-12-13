import SwiftUI

struct HomePageView: View {
    @State private var reservation1 = "予約 1"
    @State private var reservation2 = "予約 2"
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
                    Text(reservation1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservation2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(width: geometry.size.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
            .frame(height: 150)
            .padding([.leading, .trailing], 10)

            List {
                Text("2025/12/22")
                Text("2")
            }
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(reservation1: $reservation1, reservation2: $reservation2)
        }
    }
}
