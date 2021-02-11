//
//  MeView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct MeView: View {
    @State var name: String
    @State var id: String
    @State var stOrTe: String
    @State var login = true
    
    var body: some View {
        VStack{
            if self.login == false {
                ContentView()
            }else{
                VStack {
                    VStack(alignment: .leading) {
                        //【1, underline】
                        Form {
                            Text("　　名前 ： \(self.name)")
                            Text("　　身元 ： \(self.stOrTe)")
                            Text("　　ID　 ： \(self.id)")
                            Text("")
                        }
                        .offset(x: -7, y: -40) //underlineを左右に揃える
//                        .clipShape(Rectangle()) //背景を切り取る
                        .frame(width: 220, height: 169) //中に移す
                        .clipped() //背景を切り取る
//                        //【2, frame】
//                        HStack {
//                            Text("名前")
//                            .padding(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3), lineWidth: 1)) //frame
//                            .padding(5)
////                                .border(Color.gray, width: 1)
////                                .cornerRadius(20) //背景の丸めの角
//                            Text(self.name)
//                        }
//                        HStack {
//                            Text("身元")
//                            .padding(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3), lineWidth: 1)) //frame
//                            .padding(5)
//                            Text(self.stOrTe)
//                        }
//                        HStack {
//                           Text("ID　")
//                            .padding(10)
//                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3), lineWidth: 1)) //frame
//                            .padding(5)
//                           Text(self.id)
//                       }
                    }
//                    Button(action: {
//                        UserDefaults.standard.removeObject(forKey: "Id")
//                        UserDefaults.standard.removeObject(forKey: "Vercode")
//                        UserDefaults.standard.removeObject(forKey: "Name")
//                        self.login = false
//                    }) {
//                        Text("log out")
//                            .foregroundColor(Color.gray)
//                    }
                }
            }
        }
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView(name: "name??", id: "id??", stOrTe: "stOrTe??")
    }
}
