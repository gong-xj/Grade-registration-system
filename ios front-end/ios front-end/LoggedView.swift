//
//  LoggedView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct LoggedView: View {
    @State var id: String
    @State var name: String
    @State var res: String
    @State var stOrTe: String
    
    var body: some View {
        TabView {
            VStack{
                if stOrTe=="老师" {
                    StListView(res:res)
                }else{
                    ScView(res:res)
                }
            }
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

struct LoggedView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedView(id:"id??", name:"name??", res:"res??", stOrTe:"学生??")
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
