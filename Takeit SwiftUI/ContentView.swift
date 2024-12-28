import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    @State private var showSettings = false
    @State private var showNotifications = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    HomePageView()
                        .tabItem {
                            Label("ホーム", systemImage: "house")
                        }
                        .tag(1)
                    
                    LeafPageView()
                        .tabItem {
                            Label("未承諾予約", systemImage: "leaf")
                        }
                        .tag(2)
                    
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
            .navigationBarHidden(selection != 1)
        }
        .sheet(isPresented: $showSettings) {
            SettingView()
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsPageView()
        }
    }
}

#Preview {
    ContentView()
}
