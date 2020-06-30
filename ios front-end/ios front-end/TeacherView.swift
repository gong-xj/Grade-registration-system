//
//  TeacherView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct TeacherView: View {
    var body: some View {
        TabView {
           stulistView()
                .tabItem {
                     Image(systemName: "circle.fill")
                     Text("学生名单")
                }
            
           iView()
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("我")
                }
        }
    }
}

struct stulistView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("viewall:")
            List(0 ..< 5) { item in
                Text("学生名字")
            }
        }
    }
}

struct iView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("view:")
            Text("姓名：??")
            Text("身份：老师")
            Text("ID：：??")
        }
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView()
    }
}
