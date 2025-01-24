import FirebaseFirestore

// Firestoreの管理を行うクラス
class FirestoreManager: ObservableObject {
    // Firestoreのインスタンスを取得
    private let db = Firestore.firestore()
    
    // ユーザーの予約データを保持する配列（UIと連携するため@Published）
    @Published var reservationList: [ReservationData] = []
    
    // 予約データをFirestoreに保存するメソッド
    func saveReservation(_ reservation: ReservationData, completion: @escaping (Error?) -> Void) {
        do {
            // 予約データをFirestore用にエンコード
            let data = try Firestore.Encoder().encode(reservation)
            
            // Firestoreの"reservations"コレクションにドキュメントを追加
            db.collection("reservations").addDocument(data: data) { error in
                // エラーがあればcompletionで返す
                completion(error)
            }
        } catch {
            // エンコード時のエラーをcompletionで返す
            completion(error)
        }
    }
    
    // Firestoreから予約データを取得するメソッド
    func fetchReservations(completion: @escaping ([ReservationData]?, Error?) -> Void) {
        // Firestoreの"reservations"コレクションから全ドキュメントを取得
        db.collection("reservations").getDocuments { snapshot, error in
            if let error = error {
                // エラーがあればcompletionで返す
                completion(nil, error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                // ドキュメントがない場合は空の配列を返す
                completion([], nil)
                return
            }
            
            // ドキュメントをReservationData型に変換
            let reservations = documents.compactMap { document -> ReservationData? in
                // Firestoreのデータを取得
                let data = document.data()
                
                // 必要なフィールドがあるか確認
                guard let reservationDate = data["reservationDate"] as? String,
                      let reservationTime = data["reservationTime"] as? String,
                      let reservationPlace = data["reservationPlace"] as? String,
                      let reservationPost1 = data["reservationPost1"] as? String,
                      let reservationDetails = data["reservationDetails"] as? String,
                      let reservationNotes = data["reservationNotes"] as? String,
                      let isEmergency = data["isEmergency"] as? Bool,
                      let isDeal = data["isDeal"] as? Bool
                else {
                    // データが欠けている場合はnilを返して除外
                    return nil
                }
                
                // ReservationData型を生成して返す
                return ReservationData(
                    reservationDate: reservationDate,
                    reservationTime: reservationTime,
                    reservationPlace: reservationPlace,
                    reservationpost1: reservationPost1,
                    reservationDetails: reservationDetails,
                    reservationNotes: reservationNotes,
                    isEmergency: isEmergency,
                    isDeal: isDeal
                )
            }
            
            // 正常にデータを取得した場合はcompletionで返す
            completion(reservations, nil)
        }
    }
}
