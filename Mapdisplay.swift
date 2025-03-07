import SwiftUI
import MapKit

struct IdentifiableAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String?
}

struct Mapdisplay: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var reservationPlace = ""
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671), // 初期値：東京駅
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var annotation: IdentifiableAnnotation? = nil

    var body: some View {
        VStack {
            // 画面タイトル（枠の外）
            Text("Mapdisplay 画面")
                .font(.largeTitle)
                .padding()

            // カード風の枠
            VStack(alignment: .leading, spacing: 10) {
                Text("待ち合わせ場所")
                    .font(.headline)
                    .foregroundColor(.gray)

                Text(reservationPlace.isEmpty ? "データなし" : reservationPlace)
                    .font(.title3)
                    .fontWeight(.bold)

                // Mapを表示
                Map(coordinateRegion: $mapRegion, annotationItems: annotation != nil ? [annotation!] : []) { place in
                    MapMarker(coordinate: place.coordinate, tint: .red)
                }
                .frame(height: 300)
                .cornerRadius(10)

                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding()

        }
        .navigationTitle("地図を確認する")
        .onAppear {
            fetchReservationPlace()
        }
    }

    private func fetchReservationPlace() {
        firestoreManager.fetchReservations { reservations, error in
            if let error = error {
                print("Error fetching reservations: \(error.localizedDescription)")
            } else if let reservations = reservations, let latest = reservations.first {
                reservationPlace = latest.reservationPlace
                searchLocation(reservationPlace)
            }
        }
    }

    private func searchLocation(_ query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response, let item = response.mapItems.first {
                let coordinate = item.placemark.coordinate
                mapRegion.center = coordinate

                let newAnnotation = IdentifiableAnnotation(coordinate: coordinate, title: query)
                annotation = newAnnotation
            } else {
                print("Location not found: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
