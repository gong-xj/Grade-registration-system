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
    @State var pushed = false
    @State var id = "xh20200101"
    @State var vercode: String
    @State var res = ""
    @State var res2 = [String.SubSequence]()
    @State var scData = [Sc]()

    var body: some View {
        NavigationView {
            List(stData) { st in
                NavigationLink(destination: ScView(scData: scData), isActive: $pushed, label: {
                    EmptyView()
                })
                Button(action: {
                    let url = URL(string: "https://localhost:8081/view/\(self.id)/all?code=\(self.vercode)")!
                    let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
                        guard let data = data else { return }
                        self.res=String(data: data, encoding: .utf8)!
                        self.res2 = self.res.split { $0.isNewline }
                        for (i,item) in self.res2.enumerated() {
                            var scRow = Sc(id: 0, nameAndScore:"" )
                            scRow.id = i
                            scRow.nameAndScore = String(item)
                            self.scData.append(scRow)
                        }
                        if self.res != "0" {
                            self.pushed=true
                        }
                        print(self.stData)
                        print(self.scData)
                    }
                    task.resume()}){
//                    HStack {
//                        Spacer()
                        Text("查看")
//                    }
                    }
                {
                Text (st.sidAndStname)
                }
            }
            .navigationBarTitle(Text("学生名单"))
        }
    }
}

//func {
//
//}


//    var body: some View {
//        VStack{
//            if pushed == false {
//                VStack{
//                    List(stData) { st in
//                        HStack {
//                            Text (st.sidAndStname)
//                            Button(action: {
//                                let url = URL(string: "https://localhost:8081/view/\(self.id)/all?code=\(self.vercode)")!
//                                let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
//                                    guard let data = data else { return }
//                                    self.res=String(data: data, encoding: .utf8)!
//                                    self.res2 = self.res.split { $0.isNewline }
//                                    for (i,item) in self.res2.enumerated() {
//                                        var scRow = Sc(id: 0, nameAndScore:"" )
//                                        scRow.id = i
//                                        scRow.nameAndScore = String(item)
//                                        self.scData.append(scRow)
//                                    }
//                                    if self.res != "0" {
//                                        self.pushed=true
//                                    }
//                                    print(self.stData)
//                                    print(self.scData)
//                                }
//                                task.resume()}){
//                                    HStack {
//                                        Spacer()
//                                        Text("查看")
//                                    }
//                            }
//                        }
//                    }
//                }
//            }else {
//                ScView(scData:scData)
//            }
//        }
//    }

//                NavigationLink(destination: ScView(scData: scData), isActive: $pushed, label: {
//                    let url = URL(string: "https://localhost:8081/view/\(self.id)/all?code=\(self.vercode)")!
//                    let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
//                        guard let data = data else { return }
//                        self.res=String(data: data, encoding: .utf8)!
//                        self.res2 = self.res.split { $0.isNewline }
//                        for (i,item) in self.res2.enumerated() {
//                            var scRow = Sc(id: 0, nameAndScore:"" )
//                            scRow.id = i
//                            scRow.nameAndScore = String(item)
//                            self.scData.append(scRow)
//                        }
//                        if self.res != "0" {
//                            self.pushed=true
//                        }
//                        return scData
//                        print(self.scData)
//                    }
//                    task.resume()
//                })//id, vercode→
//            .navigationBarTitle(Text("学生名单"))
//        }


struct StListView_Previews: PreviewProvider {
    static var previews: some View {
        StListView(
            stData:[], vercode: "vercode??")
    }
}
