//
//  ContentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct ContentView: View, Identifiable {
    @State var id = "xh001"
//    @State var id = "xh20200101"
    @State var name = ""
    @State var vercode = ""
    @State var login = false
    @State var res = ""
    @State var stOrTe = "学生"
//    @State var res2 = "学科名 分数\n语文  85\n英语  100\n物理  100\n美术  90"
    

    var body: some View {
        VStack {
            if login==false {
                VStack {
                    VStack {
                        VStack(alignment: .center) {
                            HStack {
                                Text("ID")
                                TextField("ID", text: $id)
                            }
                            HStack {
                                Text("验证码")
                                TextField("VerCode", text: $vercode)
                                Button(action: {
                                    let url = URL(string: "https://localhost:8081/login/\(self.id)")!
                                    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                                        guard let data = data else { return }
                                        self.name = String(data: data, encoding: .utf8)!
        //                                print(String(data: data, encoding: .utf8)!)
                                    }
                                    task.resume()}) {
                                    Text("发送验证码")
                                        .foregroundColor(Color.black)
                                }
                            }
                        }
                        .padding()
                    }
                    HStack {
                        Button(action: {
//                            print(">>>登录button")
                            let url = URL(string: "https://localhost:8081/view/\(self.id)/all?code=\(self.vercode)")!
                            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                                guard let data = data else { return }
    //                                print(String(data: data, encoding: .utf8)!)
                                self.res=String(data: data, encoding: .utf8)!
                                if self.res != "0" {
                                    self.login=true
                                }
//                                print(self.res)
                                if self.id.count < 10 {
                                    self.stOrTe = "老师"
                                }
                                print(self.stOrTe)
                            }
                            
                            task.resume()}) {
                        Text("登录")
                            .foregroundColor(Color.black)
                        }
                    }
                }
            }else{
                LoggedView(id:id, name:name, res:res, stOrTe:stOrTe)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
