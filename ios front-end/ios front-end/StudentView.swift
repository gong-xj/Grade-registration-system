//
//  studentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct StudentView: View {
    var body: some View {
        TabView {
           scView()
                .tabItem {
                     Image(systemName: "circle.fill")
                     Text("成绩单")
                }
            
           meView()
                .tabItem {
                    Image(systemName: "circle.fill")
                    Text("我")
                }
        }
    }
}

struct scView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("view:")
            Text("自己的学科+成绩")
        }
    }
}

struct meView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("view:")
            Text("姓名：??")
            Text("身份：学生")
            Text("ID：：??")
        }
    }
}

struct StudentView_Previews: PreviewProvider {
    static var previews: some View {
        StudentView()
    }
}
