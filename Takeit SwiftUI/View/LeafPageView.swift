import SwiftUI
import MapKit


import MapKit // これを追加！
struct Reservation: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let location: String
    let status: String
}

struct LeafPageView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    // 選択された予約データ
    @State private var latestReservation: ReservationData?
    @State private var reservationDate = ""
    @State private var reservationTime = ""
    @State private var reservationPlace = ""
   
    @State private var reservationNotes = ""
    @State private var showReservationForm = false
    @State private var isEmergency = false
    @State private var reservationPost1 = ""
    @State private var reservationPost2 = ""
    @State private var reservationMemo = ""
    @State private var reservationAddress = ""
    @State private var reservationBuilding = ""
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.6032, longitude: 140.4648), // 初期値
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    
    @State private var selectedTab: String = "予約待ち"
    @State private var reservations: [Reservation] = [
        Reservation(date: "reservationDate", time: "19:40", location: "青森病院", status: "予約未成立"),
        Reservation(date: "8月23日", time: "19:40", location: "青森病院", status: "予約未成立")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        selectedTab = "予約待ち"
                    }) {
                        Text("予約待ち")
                            .padding()
                            .background(selectedTab == "予約待ち" ? Color.green.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedTab == "予約待ち" ? Color.green : Color.clear, lineWidth: 2)
                            )
                    }
                    Button(action: {
                        selectedTab = "予約履歴"
                    }) {
                        Text("予約履歴")
                            .padding()
                            .background(selectedTab == "予約履歴" ? Color.green.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedTab == "予約履歴" ? Color.green : Color.clear, lineWidth: 2)
                            )
                    }
                }
                .padding()
                
                VStack(spacing: 20) {
                    // ヘッダー部分のビュー
                    //HeaderView(isEmergency: .constant(latestReservation?.isEmergency ?? false))
                    Text("最新予約待ち")
                        .font(.system(size: 20, weight: .bold))
                        .fontWeight(.medium)
                    
                    // 現在の予約情報を表示するビュー
                    if let reservation = latestReservation {
                        isDealdReservationInfoView(
                            reservationDate: .constant(reservation.reservationDate),
                            reservationTime: .constant(reservation.reservationTime),
                            reservationPlace: .constant(reservation.reservationPlace),
                            reservationMap: .constant(reservation.reservationMap),
                            reservationNotes: .constant(reservation.reservationNotes),
                            showReservationForm: .constant(false),
                            reservationPost1: .constant(reservation.reservationPost1),
                            reservationPost2: .constant(reservation.reservationPost2),
                            reservationMemo: .constant(reservation.reservationMemo),
                            reservationAddress: .constant(reservation.reservationAddress),
                            reservationBuilding: .constant(reservation.reservationBuilding)
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
                   
                  
                }
                .padding()
                .sheet(isPresented: $showReservationForm) {
                    // 予約フォームビューをモーダル表示
                    ReservationFormView()
                }
                .onAppear {
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
                
                List(reservations) { reservation in
                    NavigationLink(destination: ReservationDetailView(reservation: reservation)) {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(selectedTab == "予約待ち" ? Color.red : Color.blue)
                            VStack(alignment: .leading) {
                                Text("\(reservation.date)  \(reservation.time)")
                                Text(reservation.location)
                                Text(reservation.status)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("依頼予約", displayMode: .inline)
        }
       
    }
    
    struct ReservationDetailView: View {
        let reservation: Reservation
        
        var body: some View {
            VStack {
                Text("\(reservation.date) \(reservation.time)")
                Text(reservation.location)
                Text(reservation.status)
            }
            .padding()
            .navigationBarTitle("予約詳細", displayMode: .inline)
        }
    }
    
    struct isDealdReservationInfoView: View {
        @Binding var reservationDate: Date
        @Binding var reservationTime: Date
        @Binding var reservationPlace: String
        @Binding var reservationMap: String
        @Binding var reservationNotes: String
        @Binding var showReservationForm: Bool
        @Binding var reservationPost1: String
        @Binding var reservationPost2: String
        @Binding var reservationMemo: String
        @Binding var reservationAddress: String
        @Binding var reservationBuilding: String
        
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
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("郵便番号(前半)")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationPost1)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("郵便番号(後半)")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationPost2)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("待ち合わせ場所(地図)")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationMap)
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("建物住所")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationBuilding)
                        .font(.title3)
                }
            
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("通訳する際に必要なサポート")
                        .foregroundColor(.gray)
                        .font(.body)
                    Text(reservationMemo)
                        .font(.title3)
                }
                
                
                // 地図ボタンと詳細確認ボタン
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
        }
    }
    
    
    
}

#Preview {
    LeafPageView()
}

