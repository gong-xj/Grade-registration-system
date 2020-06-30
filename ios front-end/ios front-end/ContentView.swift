//
//  ContentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var id = ""
    @State var vercode = ""

    var body: some View {
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
//                            print(">>>发送验证码button")
                            let url = URL(string: "http://localhost:8080/login/student/\(self.id)")!
                            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                                guard let data = data else { return }
                                print(String(data: data, encoding: .utf8)!)
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
                    print(">>>登录button")
                    let url = URL(string: "http://localhost:8080/view/\(self.id)/all?code=\(self.vercode)")!
                    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                        guard let data = data else { return }
                        print(String(data: data, encoding: .utf8)!)
                    }
                    task.resume()}) {
                    Text("登录")
                        .foregroundColor(Color.black)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
