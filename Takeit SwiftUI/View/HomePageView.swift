import SwiftUI

struct HomePageView: View {
    @State private var reservationDate = ""
    @State private var reservationTime = ""
    @State private var reservationPlace = ""
    @State private var reservationDetails = ""
    @State private var reservationNotes = ""
    @State private var showReservationForm = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("今週の予約")
                .font(.headline)
                .padding([.leading, .trailing], 10)
            
            GeometryReader { geometry in
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
                    
                    // HStack{
                    Text("受診内容")
                        .foregroundStyle(Color.gray)
                    Text(reservationNotes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    //}
                    
                    // HStack{
                    Text("待ち合わせ場所")
                        .foregroundStyle(Color.gray)
                    Text(reservationPlace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    // }
                    
                    
                    HStack(spacing: 17) {
                        Button(action: {
                            showReservationForm.toggle()
                        }) {
                            Text("地図を見る")
                                .padding()
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Button(action: {}) {
                            Text("詳細を確認する")
                                .padding()
                                .background(Color.green.opacity(0.3))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                            
                        }
                    }
                    
                    
                }
                
                .padding()
                .frame(width: geometry.size.width - 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .frame(width: geometry.size.width - 10) // 横幅は保持
                
            }
            
            .padding([.leading, .trailing], 10)
            
            
            HStack(spacing: 10) {
                Button(action: {
                    showReservationForm.toggle()
                }) {
                    Text("予約画面")
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
                
                /*
                 Button(action: {}) {
                 Text("予約履歴")
                 .padding()
                 .background(Color.green.opacity(0.3))
                 .cornerRadius(8)
                 .frame(maxWidth: .infinity)
                 
                 }
                 */
            }
            Text("他の予約一覧" )
            frame(maxWidth: .infinity, alignment: .leading)
            
            List {
                Text("2025/12/22")
                Text("2")
            }
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(reservationDate: $reservationDate, reservationTime: $reservationTime, reservationPlace: $reservationPlace, reservationDetails: $reservationDetails, reservationNotes: $reservationNotes)
        }
    }
}

