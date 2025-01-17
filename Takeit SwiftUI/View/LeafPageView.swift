import SwiftUI


import MapKit // これを追加！
struct Reservation: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let location: String
    let status: String
}

struct LeafPageView: View {
    @State private var reservationDate = ""
    @State private var reservationTime = ""
    @State private var reservationPlace = ""
    @State private var reservationDetails = ""
    @State private var reservationNotes = ""
    @State private var showReservationForm = false
    @State private var isEmergency = false
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
        //        .sheet(isPresented: $showReservationForm) {
        //            ReservationFormView(
        //                reservationDate: $reservationDate,
        //                reservationTime: $reservationTime,
        //                reservationPlace: $reservationPlace,
        //                reservationDetails: $reservationDetails,
        //                reservationNotes: $reservationNotes,
        //                isEmergency: $isEmergency, // State変数を渡す
        //                mapRegion: $mapRegion, // mapRegionを渡す
        //                selectedAddress: $selectedAddress // selectedAddressを渡す
        //            )
        //    }
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
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            LeafPageView()
        }
    }
    
}
