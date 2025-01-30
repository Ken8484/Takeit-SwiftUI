import Foundation

struct ReservationData: Identifiable, Codable {
    var id = UUID()
    var reservationDate: Date
    var reservationTime: Date
    var reservationPlace: String
    var reservationPost1: String
    var reservationDetails: String
    var reservationNotes: String
    var isEmergency: Bool
    var isDeal: Bool
}
