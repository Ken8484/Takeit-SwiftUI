import SwiftUI
import MapKit
import FirebaseFirestore

struct ReservationFormView: View {
    
    @Binding var reservationDate: String
    @Binding var reservationTime: String
    @Binding var reservationPlace: String
    @Binding var reservationDetails: String
    @Binding var reservationNotes: String
    @Binding var isEmergency: Bool
    @Binding var isDeal: Bool
    @Binding var mapRegion: MKCoordinateRegion // オプショナル型を削除
    @Binding var selectedAddress: String // オプショナル型を削除
    
    
    @State private var selectedDate = Date()
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    @State private var meetingPlace = ""
    @State private var placeDetails = ""
    @State private var additionalNotes = ""
    @State private var post1 = ""
    @State private var post2 = ""
    @State private var building = ""
    @State private var address = ""
    @State private var locationSearch = ""
    @State private var memo = ""
    @State private var selectedCategories: Set<String> = []
    @State private var support = ""
    
    let categories = [
        "医療", "公共機関・行政",
        "学校・教育", "職場・ビジネス",
        "日常生活", "エンタメ",
        "プライベート", "オンライン"
    ]
    
    // @State private var mapRegion = MKCoordinateRegion(
    //    center: CLLocationCoordinate2D(latitude: 40.6032, longitude: 140.4648), // 青森県弘前市
    //     span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    // )
    //@State private var selectedAddress = ""
    
    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }
    
    @Environment(\.dismiss) private var dismiss
    private let firestoreManager = FirestoreManager()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("予約希望日")) {
                    DatePicker("予約希望日", selection: $selectedDate, displayedComponents: .date)
                }
                
                Section(header: Text("待ち合わせ時間")) {
                    TimePickerView(reservationTime: $reservationTime)
                }
                Section(header: Text("待ち合わせ予約項目").font(.footnote)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("待ち合わせ場所").font(.footnote)
                        TextField("弘前大学医学部附属病院", text: $meetingPlace).textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("郵便番号").font(.footnote)
                        HStack {
                            
                            TextField("036",text: $post1)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 60)
                            Text("-")
                            TextField("8563",text: $post2)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                        }
                        Text("住所").font(.footnote)
                        TextField("青森県弘前市本町５３",text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("建物名").font(.footnote)
                        TextField("中央診療棟", text: $building)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("待ち合わせに関するメモ").font(.footnote)
                        TextField("大学病院の入口で待ち合わせをお願いします", text: $memo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    //                    .padding()
                    //                    .background(Color(UIColor.systemGray6))
                    //                    .cornerRadius(8)
                    
                }
                Section(header: Text("地図").font(.footnote)) {
                    TextField("場所を検索する", text: $locationSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    MapSelectionView(
                        mapRegion: Binding(
                            get: { self.mapRegion ?? MKCoordinateRegion() }, // nilの場合はデフォルト値を提供
                            set: { self.mapRegion = $0 }
                        ),
                        selectedAddress: Binding(
                            get: { self.selectedAddress ?? "" }, // nilの場合は空文字を提供
                            set: { self.selectedAddress = $0 }
                        ),
                        meetingPlace: $meetingPlace
                    )
                }
                
                Section(header: Text("通訳内容(ジャンル)").font(.headline).padding(.bottom, 5)) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                toggleSelection(for: category)
                                print("Selected category: \(category)") // 選択されたボタンのテキストを出力
                            }) {
                                Text(category)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedCategories.contains(category) ? Color.green : Color(UIColor.systemGray6))
                                    .foregroundColor(.primary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.borderless) // これを追加
                        }
                    }
                }
                
                Section(header: Text("通訳内容").font(.headline).padding(.bottom, 5)) {
                    TextField("インフルエンザワクチンの接種をしたい", text: $additionalNotes)
                        .cornerRadius(8)
                }
                
                Section(header: Text("必要なサポートがある場合（任意）").font(.headline).padding(.bottom, 5)) {
                    TextField("〇〇アレルギーがあるのでワクチン接種前に先生に確認したい", text: $support)
                  
                        .cornerRadius(8)
                }
                //                    Spacer()
                Toggle("緊急", isOn: $isEmergency)
                Button("予約内容を保存") {
                    let reservation = ReservationData(
                        reservationDate: "\(selectedDate.formatted())",
                        reservationTime: "\(selectedHour)時\(selectedMinute)分",
                        reservationPlace: "\(meetingPlace)",
                        reservationDetails: "\(placeDetails)",
                        reservationNotes: "\(additionalNotes)",
                        isEmergency: isEmergency,// isEmergencyを使用
                        isDeal: isDeal
                    )
                    
                    reservationDate = reservation.reservationDate
                    reservationPlace = reservation.reservationPlace
                    reservationTime = reservation.reservationTime
                    reservationDetails = reservation.reservationDetails
                    reservationNotes = reservation.reservationNotes
                    
                    firestoreManager.saveReservation(reservation) { error in
                        if let error = error {
                            print("Error saving reservation: \(error.localizedDescription)")
                        } else {
                            print("Reservation saved successfully")
                            dismiss()
                        }
                    }
                    
                    // Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.top, 20)
            }
            .navigationTitle("予約画面")
        }
    }
    
    private func fetchAddress(from coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, let address = placemark.name {
                completion(address)
            } else {
                completion("住所を取得できませんでした")
            }
        }
    }
    
    private func toggleSelection(for category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category) // 選択解除
        } else {
            selectedCategories.insert(category) // 新規選択
        }
    }
}
