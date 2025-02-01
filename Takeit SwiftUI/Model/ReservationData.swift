import Foundation

struct ReservationData: Identifiable, Codable {
    var id = UUID()
    var reservationDate: Date
    var reservationTime: Date
    var reservationMap: String
    var reservationPost1: String
    var reservationPost2: String
    var reservationPlace: String
    var reservationAddress: String
    var reservationBuilding: String
    var reservationNotes: String
    var selectedCategories: [String]
    var reservationMemo: String
    var reservationSupport: String
    var isEmergency: Bool
    var isDeal: Bool
    
}
