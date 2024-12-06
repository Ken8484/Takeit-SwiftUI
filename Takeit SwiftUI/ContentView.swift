import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    @State private var showSettings = false
    @State private var showNotifications = false

    var body: some View {
        NavigationStack {
            VStack {
                // TabViewを配置
                TabView(selection: $selection) {
                    // ホーム画面（Page 1）
                    HomePageView()
                        .tabItem {
                            Label("ホーム", systemImage: "house")
                        }
                        .tag(1)
                    
                    // Leaf（Page 2）
                    LeafPageView() // 名前を変更
                        .tabItem {
                            Label("Leaf", systemImage: "leaf")
                        }
                        .tag(2)
                    
                    // ユーザー（Page 3）
                    UserPageView()
                        .tabItem {
                            Label("ユーザー", systemImage: "person.circle")
                        }
                        .tag(3)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // 設定ボタンのアクション
                        showSettings.toggle()
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                            Text("設定")
                                .font(.caption)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // お知らせボタンのアクション
                        showNotifications.toggle()
                    } label: {
                        VStack(spacing: 2) {
                            Image(systemName: "bell")
                                .font(.title2)
                            Text("お知らせ")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationBarHidden(selection != 1) // ホーム画面以外でナビゲーションバーを非表示にする
        }
        .sheet(isPresented: $showSettings) {
            SettingsView() // 設定画面
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsView() // お知らせ画面
        }
    }
}

struct HomePageView: View { // ホーム画面
    @State private var reservation1 = "予約 1"
    @State private var reservation2 = "予約 2"
    @State private var showReservationForm = false

    var body: some View {
        VStack(spacing: 16) {
            // 予約画面ボタン
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

                Button(action: {
                    // 予約履歴のアクション
                }) {
                    Text("予約履歴")
                        .padding()
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding([.leading, .trailing], 10)

            // 「今週の予約」セクション
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 8) {
                    Text("今週の予約")
                        .font(.headline)
                        .padding(.top)
                    
                    Text(reservation1)
                        .frame(maxWidth: .infinity, alignment: .leading) // 左寄せ
                    Text(reservation2)
                        .frame(maxWidth: .infinity, alignment: .leading) // 左寄せ
                }
                .padding()
                .frame(width: geometry.size.width - 20) // 横幅を画面幅 - 20px に設定
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2) // 灰色の縁
                )
            }
            .frame(height: 150)
            .padding([.leading, .trailing], 10)

            // リスト
            List {
                Text("2025/12/22")
                Text("2")
                Text("2")
                Text("2")
                Text("2")
            }
        }
        .padding()
        .sheet(isPresented: $showReservationForm) {
            ReservationFormView(reservation1: $reservation1, reservation2: $reservation2)
        }
    }
}

struct LeafPageView: View { // Leaf画面
    var body: some View {
        Text("Leaf Content")
            .font(.largeTitle)
    }
}

struct UserPageView: View { // ユーザー画面
    var body: some View {
        Text("ユーザー情報")
            .font(.largeTitle)
    }
}

struct ReservationFormView: View { // 予約画面
    @Binding var reservation1: String
    @Binding var reservation2: String
    @State private var reservationDate = Date()
    @State private var selectedTimeHour = 9
    @State private var selectedTimeMinute = 0
    @State private var location = ""
    @State private var details = ""
    @State private var interpreter = ""
    @State private var notes = ""
    @State private var reservationContent = ""
    
    let hours = Array(9...21)
    let minutes = Array(0..<60).filter { $0 % 5 == 0 }

    var body: some View {
        NavigationStack {
            Form {
                // 予約希望日
                Section(header: Text("予約希望日")) {
                    DatePicker("予約希望日", selection: $reservationDate, displayedComponents: .date)
                        .onChange(of: reservationDate) { newValue in
                            // 月を日本語表記にする
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy年MM月dd日"
                            print(formatter.string(from: reservationDate)) // デバッグ用
                        }
                }
                
                // 待ち合わせ時間
                Section(header: Text("待ち合わせ時間")) {
                    Picker("時間", selection: $selectedTimeHour) {
                        ForEach(hours, id: \.self) { hour in
                            Text("\(hour)時")
                        }
                    }
                    
                    Picker("分", selection: $selectedTimeMinute) {
                        ForEach(minutes, id: \.self) { minute in
                            Text("\(minute, specifier: "%02d")分")
                        }
                    }
                }

                // 待ち合わせ場所
                Section(header: Text("待ち合わせ場所")) {
                    TextField("待ち合わせ場所", text: $location)
                }

                // 待ち合わせ詳細場所
                Section(header: Text("待ち合わせ詳細場所")) {
                    TextField("待ち合わせ詳細場所", text: $details)
                }

                // 希望通訳者
                Section(header: Text("希望通訳者")) {
                    TextField("希望通訳者", text: $interpreter)
                }

                // 予約内容
                Section(header: Text("予約内容")) {
                    TextField("予約内容", text: $reservationContent)
                        .frame(height: 100) // 予約内容入力欄を調整
                }

                // 備考
                Section(header: Text("備考")) {
                    TextField("備考", text: $notes)
                        .frame(height: 100) // 備考入力欄を調整
                }

                Button("予約内容を保存") {
                    reservation1 = "予約希望日: \(reservationDate.formatted())"
                    reservation2 = "予約内容: \(reservationContent)"
                    // 保存後、ホームに戻る
                    // ナビゲーションスタックに戻る処理
                }
                .padding()
                .background(Color.green.opacity(0.3))
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("予約画面")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("設定画面")
    }
}

struct NotificationsView: View {
    var body: some View {
        Text("お知らせ画面")
    }
}

#Preview {
    ContentView()
}
