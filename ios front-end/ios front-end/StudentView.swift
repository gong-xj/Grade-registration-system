//
//  studentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct StudentView: View {
    @State var id: String
    @State var name: String
    @State var res: String
//    var contentView: ContentView
//    @State var studentId = ContentView.id
    
    var body: some View {
        TabView {
            scView(res:res)
                .tabItem {
                     Image(systemName: "circle.fill")
                     Text("成绩单")
                }
            
            meView(name:name,id:id)
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("我")
                }
        }
    }
}

struct scView: View {
    @State var res: String
    
    var body: some View {
        VStack(alignment: .leading) {
//            Text("自己的学科+成绩")
            Text(self.res)
//            print(String(self.res))
//            print(String(format:"res=%@", arguments:[res]))
//            Text("view:")
//            Text("自己的学科+成绩")
        }
    }
}

struct meView: View {
    @State var name: String
    @State var id: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("姓名：\(self.name)")
            Text("身份：学生")
            Text("ID：\(self.id)")
        }
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
//        StudentView(contentView:contentView)
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
