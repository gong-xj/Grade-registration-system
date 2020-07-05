//
//  TcLoggedView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/04.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct TcLoggedView: View {
    @State var id: String
    @State var name: String
    @State var stData: [St]
    @State var stOrTe: String
    @State var vercode: String
    
    var body: some View {
        TabView {
            StListView(stData: stData, vercode:vercode)
                .tabItem {
                     Image(systemName: "circle.fill")
                     Text("成绩单")
                }
            
            MeView(name:name, id:id, stOrTe:stOrTe)
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("我")
                }
        }
    }
}

struct TcLoggedView_Previews: PreviewProvider {
    static var previews: some View {
        TcLoggedView(id: "id??", name: "name??", stData: [], stOrTe: "老师？？", vercode: "vercode??")
    }
}
