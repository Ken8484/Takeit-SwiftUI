import SwiftUI
import MapKit

struct MapSelectionView: View {
    @Binding var mapRegion: MKCoordinateRegion
    @Binding var selectedAddress: String
    @Binding var meetingPlace: String

    // 青森県弘前市の座標を初期値に設定
    private let initialLocation = CLLocationCoordinate2D(latitude: 40.6031, longitude: 140.4648)

    // マーカーのリスト
    private var annotationItems: [AnnotatedLocation] {
        [AnnotatedLocation(coordinate: mapRegion.center)]
    }

    var body: some View {
        VStack {
            Map(
                coordinateRegion: $mapRegion,
                interactionModes: [.all],
                showsUserLocation: true,
                annotationItems: annotationItems
            ) { location in
                MapMarker(coordinate: location.coordinate)
            }
            .frame(height: 200)
            .onAppear {
                // 初期表示時に青森県弘前市を設定
                mapRegion = MKCoordinateRegion(
                    center: initialLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
            .gesture(
                TapGesture().onEnded { _ in
                    let locationCoordinate = mapRegion.center
                    fetchAddress(from: locationCoordinate) { address in
                        selectedAddress = address
                        meetingPlace = address
                    }
                }
            )

            // 新しい "待ち合わせ場所Map" 項目
            Section(header: Text("待ち合わせ場所Map")) {
                Text(selectedAddress.isEmpty ? "住所が選択されていません" : selectedAddress)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding()
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

struct AnnotatedLocation: Identifiable {
    let id = UUID() // 一意の識別子
    let coordinate: CLLocationCoordinate2D
}
