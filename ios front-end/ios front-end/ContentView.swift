//
//  ContentView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/06/29.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct ContentView: View, Identifiable {
//    @State var id : String = UserDefaults.standard.string(forKey: "Id") ?? "xh001"
//    @State var vercode : String = UserDefaults.standard.string(forKey: "Vercode") ?? ""
//    @State var name : String = UserDefaults.standard.string(forKey: "Name") ?? ""
//    @State var id = "xh20200101"
    @State var id = "xh001"
    @State var vercode = "3588"
    @State var name = ""
    @State var login = false
    @State var res = ""
    @State var res2 = [String.SubSequence]()
    @State var stData = [St]()
    @State var scData = [Sc]()
    @State var stOrTe = "学生"
    

    var body: some View {
        VStack {
//            初めてlogin
//            UserDefaultsに存在するか確認
            if login == false {
//            if login == false && vercode == "" {
                VStack {
                    VStack {
                        VStack(alignment: .center) {
                            HStack {
                                Text("ID           ")
//                                .frame(width: 80, height: 30)
                                TextField("ID", text: $id)
                                .textFieldStyle(RoundedBorderTextFieldStyle()) //frame
                            }
                            HStack {
                                Text("認証番号") //日本語
//                                .frame(width: 80, height: 30)
//                                Text("验证码")　//中文
                                SecureField("VerCode", text: $vercode) //入力をdotに表示
                                .textFieldStyle(RoundedBorderTextFieldStyle()) //frame
                                Button(action: {
                                    let url = URL(string: "https://localhost:8081/login/\(self.id)")!
                                    let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
                                        guard let data = data else { return }
                                        self.name = String(data: data, encoding: .utf8)!
                                    }
                                    task.resume()}) {
//                                    Text("发送验证码")　//中文
                                        HStack {
                                            Text("発行")
                                            Image(systemName: "paperplane")
                                            
                                        }
                                        .frame(minWidth: 0, maxWidth: 80)
                                        .padding(10) //塗りつぶし?のsize
                                        .foregroundColor(Color.black) //fontの色
//                                        .font(.headline) //fontのsize
//                                        .border(Color.gray, width: 1)
//                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2)) //frame
                                        .background(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3)) //背景色
                                        .cornerRadius(20) //背景の丸めの角
                                }
                            }
                        }
                        .padding()
                    }
                    HStack {
                        Button(action: {
                            self.res = ""
                            let url = URL(string: "https://localhost:8081/view/\(self.id)/all?code=\(self.vercode)")!
                            let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
                                guard let data = data else { return }
                                self.res=String(data: data, encoding: .utf8)!
                                print(self.res)
                                if self.res != "please log in." {
                                    self.res2 = self.res.split { $0.isNewline }
                                    if self.id.count < 10 {
                                        self.stOrTe = "先生"
                                        // res2　-> st
                                        for (i,item) in self.res2.enumerated() {
                                            var stRow = St(id: 0, sidAndStname:"" )
                                            stRow.id = i
                                            stRow.sidAndStname = String(item)
                                            self.stData.append(stRow)
                                        }
                                    }else{
                                        for (i,item) in self.res2.enumerated() {
                                            var scRow = Sc(id: 0, nameAndScore:"" )
                                            scRow.id = i
                                            scRow.nameAndScore = String(item)
                                            self.scData.append(scRow)
                                        }
                                    }
                                    self.login = true
                                }
                                //id，vercode，nameのdataの永続性?：userdefault
//                                let userDefault = UserDefaults.standard
//                                userDefault.set(self.id, forKey: "Id")
//                                id = userDefault.string(forKey: "Id")
//                                userDefault.set(self.vercode, forKey: "Vercode")
//                                vercode = userDefault.string(forKey: "Vercode")
//                                userDefault.set(self.name, forKey: "Name")
//                                name = userDefault.string(forKey: "Name")
//                                print("userDefault = \(userDefault)")
                            }
                            task.resume()}) {
                                HStack {
                                    Text("ログイン")
                                    Image(systemName: "arrowshape.turn.up.right")
                                }
                                .frame(minWidth: 0, maxWidth: 200)
    //                            .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(10)
                                .foregroundColor(Color.black)
                                .background(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3))
                                .cornerRadius(20)
                        }
                    }
                }
            }else if login == true {
                VStack {
//                    if self.stOrTe == "老师" {
                    if self.stOrTe == "先生" {
                        TcLoggedView(id:id, name:name, stData:stData, stOrTe:stOrTe, vercode:vercode)
                    }else {
                        StLoggedView(id:id, name:name, scData:scData, stOrTe:stOrTe)
                    }
                }
            }
        }
    }
    
//    init(){
//        print("init啦") //test
//        if vercode != "" {
//            print("vercode不为nil啦") //test
//            let url = URL(string: "https://localhost:8081/view/\(id)/all?code=\(vercode)")!
//            let a = self //否则报错：Escaping closure captures mutating 'self' parameter
//            let task = URLSession(configuration: .default, delegate: AllowsSelfSignedCertificateDelegate(), delegateQueue: nil).dataTask(with: url) {(data, response, error) in
//                guard let data = data else { return }
//                a.res=String(data: data, encoding: .utf8)!
//                a.res2 = a.res.split { $0.isNewline }
//                if a.id.count < 10 {
//                    a.stOrTe = "老师"
//                    //res2转化为st格式
//                    for (i,item) in a.res2.enumerated() {
//                        var stRow = St(id: 0, sidAndStname:"" )
//                        stRow.id = i
//                        stRow.sidAndStname = String(item)
//                        a.stData.append(stRow)
//                    }
//                }else{
//                    for (i,item) in a.res2.enumerated() {
//                        var scRow = Sc(id: 0, nameAndScore:"" )
//                        scRow.id = i
//                        scRow.nameAndScore = String(item)
//                        a.scData.append(scRow)
//                    }
//                }
//                if a.res != "0" {
//                    a.login=true
//                }
//            }
//            task.resume() //可删掉
//        }
//    }
}


class AllowsSelfSignedCertificateDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace

        // 認証チャレンジタイプがサーバ認証かどうか確認
        // 通信対象のホストは想定しているものかどうか確認
        guard protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            protectionSpace.host == "localhost",
            let serverTrust = protectionSpace.serverTrust else {
                // 特別に検証する対象ではない場合はデフォルトのハンドリングを行う
                completionHandler(.performDefaultHandling, nil)
                return
        }

        // 受け取った証明書は許可すべきかどうか確認
        // (serverTrustオブジェクトを用いて.cerファイルや.derファイルと突き合わせるなど)
        if true {
//        if checkValidity(of: serverTrust) {
            // 通信を継続して問題ない場合は、URLCredentialオブジェクトを作って返す
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            // 通信を中断させたい場合は、cancelを返す
//            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
