import SwiftUI

struct UserPageView: View {
    @State private var name: String = "山田太郎"
    @State private var age: String = "18歳"
    @State private var gender: String = "男性"
    @State private var occupation: String = "大学生"
    @State private var hearingLevel: String = "四級"
    @State private var phoneNumber: String = "0902222333"
    @State private var email: String = "taro@gmail.com"
    @State private var userID: String = "Taro123"
    
    @State private var isEditing: Bool = false // 編集モードかどうか
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    UserInfoRow(label: "名前", value: $name, isEditing: isEditing)
                    UserInfoRow(label: "年齢", value: $age, isEditing: isEditing)
                    UserInfoRow(label: "性別", value: $gender, isEditing: isEditing)
                    UserInfoRow(label: "職業", value: $occupation, isEditing: isEditing)
                    UserInfoRow(label: "聴覚レベル", value: $hearingLevel, isEditing: isEditing)
                    UserInfoRow(label: "電話番号", value: $phoneNumber, isEditing: isEditing)
                    UserInfoRow(label: "メールアドレス", value: $email, isEditing: isEditing)
                    UserInfoRow(label: "ユーザーID", value: $userID, isEditing: isEditing)
                }
                
                Button(action: {
                    isEditing.toggle() // 編集モードを切り替え
                }) {
                    Text(isEditing ? "完了" : "編集する")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(isEditing ? Color.green : Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("ユーザー画面")
        }
    }
}

struct UserInfoRow: View {
    let label: String
    @Binding var value: String
    let isEditing: Bool // 編集モードかどうか
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            Spacer()
            if isEditing { // 編集モードの場合はTextField
                TextField("入力してください", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else { // 表示モードの場合はText
                Text(value)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 5)
    }
}
