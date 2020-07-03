//
//  StListView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct StListView: View {
    @State var res: String
    @State var stList: [String]=[]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("学生名单")
            List(0 ..< 5) { item in
//                String(self.res.split { $0.isNewline })
//                self.stList = String(self.res.split { $0.isNewline })
//                self.stList
//                self.res
//                VStack {
                    Text(self.res)
//                }
//                VStack {
//                    Text(self.stList)
//                }
//                Text({
//                    self.stList = self.res.split { $0.isNewline }
//                    print(self.stList)
//                })
//                Text({
//                    var lines: [String] = []
//                    res.enumerateLines { line, _ in
//                        lines.append(line)
//                    }
//                }
//                )
            }
        }
    }
}

struct StListView_Previews: PreviewProvider {
    static var previews: some View {
//        StListView(res: "res??:StList")
        StListView(res: " 张三\n 李四\n 小a\n 小b\n 小c\n 小d\n 小e\n 小f\n 小g\n 小h\n 张三")
//        StListView(stList: ["张三","李四","小a"])
        
    }
}
