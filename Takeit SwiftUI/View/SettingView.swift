import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: HomePageView()) {
                    Text("ユーザーログイン")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 50)
                
                NavigationLink(destination: InterpreterHomePageView()) {
                    Text("通訳者ログイン")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 50)
            }
            .navigationTitle("設定")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // 戻るボタンのアクション
                        dismissView()
                    }) {
                        Image(systemName: "chevron.backward")
                        Text("戻る")
                    }
                }
            }
        }
    }
    
    private func dismissView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
