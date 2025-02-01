import SwiftUI
import MapKit
import FirebaseFirestore


// 予約フォームのビュー
struct ReservationFormView: View {
    // 内部状態を管理する変数
    @State private var selectedDate = Date() // 日付ピッカー用の選択日
    @State private var reservationTime = Date()// 時間
    @State private var meetingMap = "" // 地図で入力
    @State private var post1 = "" // 郵便番号の前半
    @State private var post2 = "" // 郵便番号の後半
    @State private var building = "" // 建物名
    @State private var address = "" // 住所
    @State private var meetingPlace = "" // 直接入力
    @State private var memo = "" // メモ
    @State private var support = "" // サポート
    @State private var selectedCategories: Set<String> = [] // ジャンルの選択状態
    @State private var Notes = "" // 詳細情報
    @State private var isEmergency = false // 緊急フラグ
    @State private var mapRegion = MKCoordinateRegion() // 地図の中心位置
    @State private var selectedAddress = "" // 選択された住所
    @State private var DmeetingPlace = "" //
    
    
    // ジャンルリスト
    let categories = [
        "医療", "公共機関・行政",
        "学校・教育", "職場・ビジネス",
        "日常生活", "エンタメ",
        "プライベート", "オンライン"
    ]
    
    @Environment(\.dismiss) private var dismiss // モーダルを閉じる環境値
    private let firestoreManager = FirestoreManager() // Firestoreへのデータ保存用マネージャ
    
    var body: some View {
        NavigationStack {
            Form {
                // 日付セクション
                Section(header: Text("予約希望日")) {
                    DatePicker("予約希望日", selection: $selectedDate, displayedComponents: .date)
                }
                
                // 時間セクション
                Section(header: Text("待ち合わせ時間")) {
                    TimePickerView(reservationTime: $reservationTime)
                }
                
                // 待ち合わせ場所セクション
                Section(header: Text("待ち合わせ予約項目")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("待ち合わせ場所")
                            .font(.footnote)
                        TextField("例: 弘前大学医学部附属病院", text: $meetingPlace)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("郵便番号").font(.footnote)
                        HStack {
                            TextField("000", text: $post1)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 60)
                            Text("-")
                            TextField("0000", text: $post2)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                        }
                        
                        Text("住所").font(.footnote)
                        TextField("例: 青森県弘前市本町53", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("建物名").font(.footnote)
                        TextField("例: 中央診療棟", text: $building)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("待ち合わせに関するメモ").font(.footnote)
                        TextField("例: 大学病院の入口で待ち合わせをお願いします", text: $memo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                // 地図セクション
                Section(header: Text("地図")) {
                    TextField("場所を検索する", text: $meetingMap)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    MapSelectionView(
                        mapRegion: $mapRegion,
                        selectedAddress: $selectedAddress,
                        meetingPlace: $meetingPlace
                        
                    )
                }
                
                // ジャンルセクション
                Section(header: Text("通訳内容(ジャンル)")) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                toggleSelection(for: category)
                            }) {
                                Text(category)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedCategories.contains(category) ? Color.green : Color(UIColor.systemGray6))
                                    .foregroundColor(.primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                
                // 詳細情報セクション
                Section(header: Text("通訳内容")) {
                    TextField("例: インフルエンザワクチンの接種をしたい", text: $Notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // サポートセクション
                Section(header: Text("必要なサポートがある場合（任意）")) {
                    TextField("例: 〇〇アレルギーがあるのでワクチン接種前に先生に確認したい", text: $support)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // 緊急スイッチ
                Toggle("緊急", isOn: $isEmergency)
                
                // 保存ボタン
                Button("予約内容を保存") {
                    saveReservation()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top, 20)
                .buttonStyle(.borderless)
            }
            .navigationTitle("予約画面")
        }
    }
    
    // ジャンル選択状態を切り替える
    private func toggleSelection(for category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    // 予約内容を保存
    private func saveReservation() {
        let selectedCategoriesArray = Array(selectedCategories) // Setを配列に変換
        
        let reservation = ReservationData(
            reservationDate: selectedDate, // ←ここは変数名のままでOK！保存するときはDate型で保存して、表示するときにフォーマット化するのでこのタイミングではDate型のままで保存するでOK！
            reservationTime: reservationTime,  // ←ここは変数名のままでOK！保存するときはDate型で保存して、表示するときにフォーマット化するのでこのタイミングではDate型のままで保存するでOK！
            reservationMap: meetingMap,
            reservationPost1: post1,
            reservationPost2: post2,
            reservationPlace: meetingPlace,
            reservationAddress: address,
            reservationBuilding: building,
            reservationNotes: Notes,
            selectedCategories: selectedCategoriesArray,
            reservationMemo: memo,
            reservationSupport: support,
            isEmergency: isEmergency,
            isDeal: false // 必要に応じて更新
        )
        
        firestoreManager.saveReservation(reservation) { error in
            if let error = error {
                print("Error saving reservation: \(error.localizedDescription)")
            } else {
                print("Reservation saved successfully")
                dismiss()
            }
        }
    }
}

#Preview {
    ReservationFormView()
}
