//
//  MeView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct MeView: View {
    @State var name: String
    @State var id: String
    @State var stOrTe: String
    @State var login = true
    
    var body: some View {
//        VStack{
//            if self.login == false {
//                ContentView()
//            }else{
                VStack {
                    VStack(alignment: .leading) {
                        Text("姓名：\(self.name)")
                        Text("身份：\(self.stOrTe)")
                        Text("ID：\(self.id)")
                    }
                    Button(action: {
                        UserDefaults.standard.removeObject(forKey: "Url")
                        UserDefaults.standard.removeObject(forKey: "Name")
                        self.login = false
                    }) {
                        Text("退出登录")
                            .foregroundColor(Color.gray)
                    }
                }
//            }
//        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView(name: "name??", id: "id??", stOrTe: "stOrTe??")
    }
}
