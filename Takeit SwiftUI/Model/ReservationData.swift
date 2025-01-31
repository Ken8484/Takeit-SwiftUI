import Foundation

struct ReservationData: Identifiable, Codable {
    var id = UUID()
    var reservationDate: Date
    var reservationTime: Date
    var reservationPlace: String
    var reservationPost1: String
    var reservationPost2: String
    var DreservationPlace: String
    var reservationaddress: String
    var reservationbuilding: String
    var reservationNotes: String
    var selectedCategories: [String]
    var reservationMemo: String
    var reservationSupport: String
    var isEmergency: Bool
    var isDeal: Bool
    
}
