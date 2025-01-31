import Foundation

// これが拡張機能的な役割のExtensionってやつ！
// 今回はDateについてのExtensionなので、extension Dateって書くよ！
extension Date {
    /// Dateを指定されたフォーマットのStringに変換する
    
    /// 「⚪︎月⚪︎日」の形式で日付を文字列に変換
    /// - Returns: 「1月25日」などの文字列
    func toMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // 日本語ロケールを指定
        formatter.dateFormat = "M月d日" // フォーマットを指定、「M」は月、「d」は日付
        return formatter.string(from: self)
    }
    
    /// 「時:分」の形式で時間を文字列に変換
    func toTimeString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP") // 日本語ロケールを指定
        formatter.dateFormat = "H:mm" // 「時:分」形式、「H」は時間、「mm」は分(05的な感じで表示される)
        return formatter.string(from: self)
    }
}
