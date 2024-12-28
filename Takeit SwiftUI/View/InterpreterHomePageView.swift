import SwiftUI

struct InterpreterHomePageView: View {
    @State private var reservations: [ReservationData] = []
    @State private var reservationDate = ""
    @State private var reservationTime = ""
    @State private var reservationPlace = ""
    @State private var reservationDetails = ""
    @State private var reservationNotes = ""
    @State private var showReservationForm = false
    @State private var isEmergency = false
    
    
    private let firestoreManager = FirestoreManager()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("今週の予約")
                .font(.title)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 10)
            VStack(alignment: .leading, spacing: 8) {
                Text(reservationDate)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text("待ち合わせ時間")
                        .foregroundStyle(Color.gray)
                    Text(reservationTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.largeTitle)
                }
                HStack{
                    Text("受診内容")
                        .foregroundStyle(Color.gray)
                    Text(reservationNotes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack{
                    Text("待ち合わせ場所")
                        .foregroundStyle(Color.gray)
                    Text(reservationPlace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack(spacing: 17) {
                    Button(action: {
                        showReservationForm.toggle()
                    }) {
                        
                        HStack{
                            Image(systemName: "map")
                            Text("地図を見る")
                                .font(.callout)
                                .padding()
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    Button(action: {}) {
                        Text("詳細を確認する")
                            .font(.callout)
                            .padding()
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding([.leading, .trailing], 10)
            HStack(spacing: 10) {
                Button(action: {
                    showReservationForm.toggle()
                }) {
                    Text("予約希望一覧")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                    
                }
            }
            Text("他の予約一覧" )
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            List(reservations) { reservation in
                HStack {
                    Text (reservation.reservationDate)
                        .foregroundStyle (Color.gray)
                    Text (reservation.reservationPlace)
                }
            }
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(reservationDate: $reservationDate, reservationTime: $reservationTime, reservationPlace: $reservationPlace, reservationDetails: $reservationDetails, reservationNotes: $reservationNotes, isEmergency: $isEmergency)
        }
        .onAppear{
            fetchReservations()
        }
    }
    
    private func fetchReservations() {
        firestoreManager.fetchReservations { fetchedReservations , error in
            if let error = error {
                print("Error fetching reservations: \(error.localizedDescription)")
                return
            }
            reservations = fetchedReservations ?? []
        }
    }
    
    
}
#Preview {
    InterpreterHomePageView()
}
