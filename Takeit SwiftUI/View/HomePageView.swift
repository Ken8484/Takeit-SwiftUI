import SwiftUI
import MapKit

// ホーム画面全体のUIを構築するためのビュー
struct HomePageView: View {
    // FirestoreManagerのインスタンスをStateObjectで管理
    @StateObject private var firestoreManager = FirestoreManager()
    // 選択された予約データ
    @State private var latestReservation: ReservationData?
    
    // 予約の日付を管理するState変数
    @State private var reservationDate = "6月6日(金)"
    // 予約の時間を管理するState変数
    @State private var reservationTime = "12:00"
    // 予約場所を管理するState変数
    @State private var reservationPlace = "青森病院\n東館 1F 受付カウンター"
    // 予約の詳細情報を管理するState変数
    @State private var reservationDetails = ""
    // 予約に関する追加メモを管理するState変数
    @State private var reservationNotes = "○○について受診したい"
    // 予約フォームの表示状態を管理するState変数
    @State private var showReservationForm = false
    // 緊急状態かを管理するState変数
    @State private var isEmergency = false
    // 予約完了かを管理するState変数
    @State private var isDeal = false
    // 地図の中心位置と表示範囲を管理するState変数
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.6032, longitude: 140.4648), // 初期値
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // 選択された住所を保持するState変数
    @State private var selectedAddress = ""
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                // ヘッダー部分のビュー
                HeaderView(isEmergency: .constant(latestReservation?.isEmergency ?? false))
                
                // 現在の予約情報を表示するビュー
                if let reservation = latestReservation {
                    ReservationInfoView(
                        reservationDate: .constant(reservation.reservationDate),
                        reservationTime: .constant(reservation.reservationTime),
                        reservationPlace: .constant(reservation.reservationPlace),
                        reservationNotes: .constant(reservation.reservationNotes),
                        showReservationForm: .constant(false)
                    )
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("現在予約はされていません")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 185, alignment: .leading) // 高さを固定
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                }
                
                // ボタンパネルのビュー
                ButtonPanel(showReservationForm: $showReservationForm)
                
                // 他の予約情報を一覧で表示するビュー
                OtherReservationsView()
            }
            .padding()
            .sheet(isPresented: $showReservationForm) {
                // 予約フォームビューをモーダル表示
                ReservationFormView()
            }
            .onAppear {     // onAppearは画面が表示された時に使われる
                // Firestoreからデータを取得
                firestoreManager.fetchReservations { reservations, error in
                    if let error = error {
                        print("Error fetching reservations: \(error.localizedDescription)")
                    } else if let reservations = reservations, !reservations.isEmpty {
                        firestoreManager.reservationList = reservations
                        latestReservation = reservations.first // 最初の予約を選択
                    }
                }
            }
        }
    }
}

// MARK: - Header View
// ページのヘッダー部分を表示するビュー
struct HeaderView: View {
    @Binding var isEmergency: Bool
    
    var body: some View {
        HStack {
            // 緊急状態に応じた色を表示する丸
            Circle()
                .fill(isEmergency ? Color.red : Color.green)
                .frame(width: 20, height: 20)
            // ヘッダーのタイトル
            Text("今週の予約")
                .font(.title)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 10)
        }
    }
}

// MARK: - Reservation Info View

// 現在の予約情報を表示するビュー
struct ReservationInfoView: View {
    @Binding var reservationDate: Date
    @Binding var reservationTime: Date
    @Binding var reservationPlace: String
    @Binding var reservationNotes: String
    @Binding var showReservationForm: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // 待ち合わせ時間
                VStack(alignment: .leading, spacing: 5) {
                    Text("待ち合わせ時間")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationDate.toMonthDayString()) // ← Date型を「⚪︎月⚪︎日」の文字列に変換する関数を使う「toMonthDayString()」(これはDateに関するExtensionで定義したものだよ！)
                        .font(.system(size: 20, weight: .bold))
                        .fontWeight(.medium)
                }
                Spacer()
                Text(reservationTime.toTimeString()) // ← Date型を「⚪:⚪︎」の文字列に変換する関数を使う「toTimeString()」(これはDateに関するExtensionで定義したものだよ！)
                    .font(.system(size: 50, weight: .bold))
                    .frame(alignment: .trailing)
            }
            
            // 予約内容
            VStack(alignment: .leading, spacing: 5) {
                Text("予約内容")
                    .foregroundColor(.gray)
                    .font(.body)
                Text(reservationNotes)
                    .font(.title3)
            }
            
            // 待ち合わせ場所
            VStack(alignment: .leading, spacing: 5) {
                Text("待ち合わせ場所")
                    .foregroundColor(.gray)
                    .font(.body)
                Text(reservationPlace)
                    .font(.title3)
            }
            
            // 地図ボタンと詳細確認ボタン
            HStack(spacing: 10) {
                Button(action: {
                    // 地図を見るアクション
                    
                }) {
                    HStack {
                        Image(systemName: "map")
                        Text("地図を見る")
                            .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                }
                
                NavigationLink(destination: CheckDetails()) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("詳細を確認する")
                            .font(.caption)
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
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}




struct Details: View {
    var body: some View {
        NavigationStack {
          
                NavigationLink(destination: CheckDetails()) {
                    Text("Check Details へ移動")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                
            }
            .navigationTitle("ホーム")
        }
    }
}
// MARK: - Button Panel
// 予約関連の操作ボタンを表示するパネル
struct ButtonPanel: View {
    @Binding var showReservationForm: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                // 予約フォームを開くアクション
                showReservationForm.toggle()
            }) {
                Text("予約画面")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Other Reservations View
// 他の予約情報を表示するビュー
struct OtherReservationsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // セクションのタイトル
            Text("他の予約一覧")
                .font(.title2)
                .bold()
            // 個々の予約を表示
            ReservationRow(date: "2024年12月27日,  12:00", place: "白樺会場", iconColor: .red)
            ReservationRow(date: "2024年12月28日,  10:00", place: "池の平ホテル玄関", iconColor: .green)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(4)
    }
}

// MARK: - Reservation Row
// 個別の予約情報を表示する行
struct ReservationRow: View {
    let date: String
    let place: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            // 状態を表すアイコン
            Image(systemName: "info.circle")
                .foregroundColor(iconColor)
            VStack(alignment: .leading) {
                // 予約の日付
                Text(date)
                    .font(.body)
                // 予約の場所
                Text(place)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
}

#Preview {
    HomePageView()
}
