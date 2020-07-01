//
//  ContentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

//class BCModel:ObservableObject{
//   @Published var id = ""
//   @Published  var vercode = ""
//   @Published  var login = false
//}

struct ContentView: View, Identifiable {
    @State var id = ""
    @State var name = ""
    @State var vercode = ""
    @State var login = false
    @State var res = ""
    @State var res2 = "学科名 分数\n语文  85\n英语  100\n物理  100\n美术  90"
    

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
                                    let url = URL(string: "http://localhost:8080/login/student/\(self.id)")!
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
                            let url = URL(string: "http://localhost:8080/view/\(self.id)/all?code=\(self.vercode)")!
                            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                                guard let data = data else { return }
    //                                print(String(data: data, encoding: .utf8)!)
                                let res=String(data: data, encoding: .utf8)!
                                print(res)
                                if res != "0" {
                                    self.login=true
                                }
                            }
                        task.resume()}) {
                        Text("登录")
                            .foregroundColor(Color.black)
                        }
                    }
                }
            }else{
//                Text(res2)
                Text(res)
//                    .fixedSize(horizontal: false, vertical: true)
//                    .padding()
//                Text("学科名 分数\n语文  85\n英语  100\n物理  100\n美术  90")
//                StudentView(id:id, name:name, res:res)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
