import SwiftUI

struct HomePageView: View {
    @State private var reservationDate = ""
    @State private var reservationTime = ""
    @State private var reservationPlace = ""
    @State private var reservationDetails = ""
    @State private var reservationNotes = ""
    @State private var showReservationForm = false
    @State private var isEmergency = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack{
                Circle()
                    .fill(isEmergency ? Color.red : Color.green) // State変数を使用
                    .frame(width: 20, height: 20)
                    .frame(alignment: .leading)
                    .padding(10)
                Text("今週の予約")
                    .font(.title)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 10)
               
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(reservationDate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("待ち合わせ時間")
                        .foregroundStyle(Color.gray)
                    Text(reservationTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                }
                HStack {
                    Text("受診内容")
                        .foregroundStyle(Color.gray)
                    Text(reservationNotes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Text("待ち合わせ場所")
                        .foregroundStyle(Color.gray)
                    Text(reservationPlace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Button(action: {
                        // 地図を見るアクション
                    }) {
                        HStack {
                            Image(systemName: "map")
                            Text("地図を見る")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // 詳細を確認するアクション
                        showReservationForm.toggle()
                    }) {
                        HStack {
                            Image(systemName: "chevron.right")
                            Text("詳細を確認")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding([.leading, .trailing], 10)
            HStack(spacing: 10) {
                Button(action: {
                    showReservationForm.toggle()
                }) {
                    Text("予約画面")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            Text("他の予約一覧")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 12) {
                Text("他の予約一覧")
                    .font(.title2)
                    .bold()
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.red)
                    VStack(alignment: .leading) {
                        Text("2024年12月27日,  12:00")
                            .font(.body)
                        Text("白樺会場")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("2024年12月28日,  10:00")
                            .font(.body)
                        Text("池の平ホテル玄関")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(4)
            .shadow(radius: 4)
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(
                reservationDate: $reservationDate,
                reservationTime: $reservationTime,
                reservationPlace: $reservationPlace,
                reservationDetails: $reservationDetails,
                reservationNotes: $reservationNotes,
                isEmergency: $isEmergency // State変数を渡す
            )
        }
    }
}

#Preview {
    HomePageView()
}
