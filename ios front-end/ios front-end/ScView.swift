//
//  ScView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct ScView: View {
    @State var scData: [Sc]
    
    var body: some View {
        List(scData) { sc in
            Text(sc.nameAndScore)
        }
//        NavigationView {
//            List(scData) { sc in
////                NavigationLink(destination: 跳转界面(数据结构: 数据结构))
////                {
//                Text (sc.nameAndScore)
////                }
//            }
//            .navigationBarTitle(Text("成绩单"))
//        }
    }
}

struct ScView_Previews: PreviewProvider {
    static var previews: some View {
        ScView(scData: [])
    }
}
