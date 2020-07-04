//
//  StLoggedView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/04.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct StLoggedView: View {
    @State var id: String
    @State var name: String
    @State var scData: [Sc]
    @State var stOrTe: String
    
    var body: some View {
        TabView {
            ScView(scData:scData)
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

struct StLoggedView_Previews: PreviewProvider {
    static var previews: some View {
        StLoggedView(id:"id??", name:"name??", scData:[], stOrTe:"学生??")
    }
}
