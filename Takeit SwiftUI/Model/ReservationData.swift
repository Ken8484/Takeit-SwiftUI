import Foundation

struct ReservationData: Identifiable, Codable {
    var id = UUID()
    var reservationDate: String
    var reservationTime: String
    var reservationPlace: String
    var reservationpost1: String
    var reservationDetails: String
    var reservationNotes: String
    var isEmergency: Bool
    var isDeal: Bool
}
