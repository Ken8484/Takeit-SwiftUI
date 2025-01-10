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
    @Binding var mapRegion: MKCoordinateRegion // オプショナル型を削除
    @Binding var selectedAddress: String // オプショナル型を削除

    
    @State private var selectedDate = Date()
    @State private var selectedHour = 9
    @State private var selectedMinute = 0
    @State private var meetingPlace = ""
    @State private var placeDetails = ""
    @State private var additionalNotes = ""
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
                
                
                
                
                
                
                Section(header: Text("待ち合わせ場所")) {
                    TextField("待ち合わせ場所", text: $meetingPlace)
                }
                Section(header: Text("地図")) {
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
                Section(header: Text("待ち合わせ場所(詳細)")) {
                    TextField("詳細", text: $placeDetails)
                }
                
                
                
                Section(header: Text("通訳内容")) {
                    TextField("通訳内容", text: $additionalNotes)
                }
                Toggle("緊急", isOn: $isEmergency)
                
                HStack {
                    Spacer()
                    Button("予約内容を保存") {
                        let reservation = ReservationData(
                            reservationDate: "\(selectedDate.formatted())",
                            reservationTime: "\(selectedHour)時\(selectedMinute)分",
                            reservationPlace: "\(meetingPlace)",
                            reservationDetails: "\(placeDetails)",
                            reservationNotes: "\(additionalNotes)",
                            isEmergency: isEmergency// isEmergencyを使用
                            
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
                    }
                    Spacer()
                }
            }
            .navigationTitle("予約画面")
            .navigationBarTitleDisplayMode(.inline)
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
}
