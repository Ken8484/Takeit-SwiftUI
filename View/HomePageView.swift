import SwiftUI

struct HomePageView: View {
    @State private var reservation1 = "予約希望日"
    @State private var reservation2 = "待ち合わせ時間"
    @State private var reservation3 = "待ち合わせ場所"
    @State private var reservation4 = "待ち合わせ場所(詳細)"
    @State private var reservation5 = "通訳内容"
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
                    Text(reservation3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservation4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(reservation5)
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
            ReservationFormView(reservation1: $reservation1, reservation2: $reservation2, reservation3: $reservation3, reservation4: $reservation4, reservation5: $reservation5)
        }
    }
}
