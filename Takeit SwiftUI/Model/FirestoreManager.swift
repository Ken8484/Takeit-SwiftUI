import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()
    @Published var users: [ReservationData] = []
    
    func saveReservation(_ reservation: ReservationData, completion: @escaping (Error?) -> Void) {
        do {
            let data = try Firestore.Encoder().encode(reservation)
            db.collection("reservations").addDocument(data: data) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    func fetchReservations(completion: @escaping ([ReservationData]?, Error?) -> Void) {
            db.collection("reservations").getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([], nil)
                    return
                }
                
                // documents から ReservationData に変換する
                let reservations = documents.compactMap { document -> ReservationData? in
                    // Firestore上の各フィールドを手動で取り出す
                    let data = document.data()
                    
                    // ここで正しくデータが存在しない場合の安全策を取る
                    guard let reservationDate = data["reservationDate"] as? String,
                          let reservationTime = data["reservationTime"] as? String,
                          let reservationPlace = data["reservationPlace"] as? String,
                          let reservationDetails = data["reservationDetails"] as? String,
                          let reservationNotes = data["reservationNotes"] as? String,
                          let isReserved = data["isReserved"] as? Bool 
                    
                    else {
                        // 必要なフィールドが欠けていたらnilを返し除外
                        return nil
                    }
                    
                    // ReservationDataを生成
                    var item = ReservationData(
                        reservationDate: reservationDate,
                        reservationTime: reservationTime,
                        reservationPlace: reservationPlace,
                        reservationDetails: reservationDetails,
                        reservationNotes: reservationNotes,
                        isReserved: isReserved
                        
                        
                    )
                    
                    // FirestoreのdocumentIDを使いたい場合は、別のプロパティに代入する
                    // item.docID = document.documentID
                    return item
                }
                
                completion(reservations, nil)
            }
        }


}
