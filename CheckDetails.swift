import SwiftUI

struct CheckDetails: View {
    var body: some View {
        VStack {
            Text("Check Details 画面")
                .font(.largeTitle)
                .padding()

            Text("ここに詳細情報を表示します")
                .padding()
        }
        .navigationTitle("詳細情報")
    }
}


