//
//  StListView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct StListView: View {
    @State var stData: [St]

    var body: some View {
        NavigationView {
            List(stData) { st in
//                NavigationLink(destination: 跳转界面(数据结构: 数据结构))
//                {
                Text (st.name)
//                }
            }
            .navigationBarTitle(Text("学生名单"))
        }
    }
}

struct StListView_Previews: PreviewProvider {
    static var previews: some View {
        StListView(
            stData:[])
    }
}
