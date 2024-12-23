//
//  NotificationsView.swift
//  Takeit SwiftUI
//
//  Created by 小田桐健太郎 on 2024/12/13.
//

import SwiftUI

struct NotificationsPageView: View {
    var body: some View {
        Text("NotificationsContents")
        
        List {
            Text("お知らせ1")
            Text("お知らせ2")
        }
    }
    
    
}


#Preview {
    NotificationsPageView()
}
