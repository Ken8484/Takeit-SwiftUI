//import FirebaseFirestore
//
//class ReservationDataViewModel: ObservableObject {
//    private var db = Firestore.firestore()
//    // struct Userをデータ型に使う
//    @Published var users: [ReservationData] = []
//    
//    // データの追加をするメソッド
//    func saveUser(name: String, completion: @escaping (Error?) -> Void) {
//        let docRef = db.collection("users").document()
//        
//        let user = ReservationData(id: docRef.documentID, Date: date, createdAt: Timestamp(), place:)
//        
//        docRef.setData([
//            "id": user.id,
//            
//            "createdAt": user.createdAt
//        ]) { error in
//            completion(error)
//        }
//    }
//    
//    // データを取得して表示するメソッド
//    func fetchUsers() {
//        db.collection("users").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                self.users = snapshot?.documents.map {
//                    ReservationData(id: $0.documentID,
//                                    createdAt: $0.data()["createdAt"] as? Timestamp ?? Timestamp(),
//                                    place: $0.data()["place"] as? String ?? "",
//                                    placedetail: $0.data()["place"] as? String ?? "",
//                                    content: $0.data()["place"] as? String ?? "",
//                                    isReserved: <#T##Bool#>
//                    )
//                    
//                } ?? []
//            }
//        }
//    }
//}

