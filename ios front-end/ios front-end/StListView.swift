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
    @State var vercode: String
    
    @State var pushed = false
    @State var id = ""
    @State var stName = ""
    @State var res = ""
    @State var res2 = [String.SubSequence]()
    @State var scData = [Sc]()

    
    var body: some View {
        NavigationView {
            VStack{
//                NavigationLink(destination: NewView(), isActive: self.$pushed, label: { //检查
                NavigationLink(destination: ScView(scData: self.scData, name: self.stName), isActive: self.$pushed, label: {
                    EmptyView()
                })
                List(stData) { st in
                    Text (st.sidAndStname)
//                    Button(action: {self.pushed=true}) //检查
                    Button(action: {
                        self.scData = [Sc]()
                        let selectedStData = st.sidAndStname.split(separator: " ").map(String.init)
//                        let selectedStData = st.sidAndStname.components(separatedBy:" ")
                        self.id = selectedStData[0]
                        self.stName = selectedStData[1]
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
                            if self.res != "please log in." {
                                self.pushed = true
                            }
                        }
                        task.resume()
                    })
                    {
                        HStack {
                            Spacer()
//                            Text("詳細")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
//            .navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange, NSFontAttributeName : UIFont.systemFont(ofSize: 25)]
            .navigationBarTitle(Text("学生リスト")
//                .font(.headline)
//                .font(.system(size: 12, weight: .light, design: .serif))
            )
//            let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.blackColor(),NSFontAttributeName : UIFont.boldSystemFontOfSize(18)]
//            .font(.headline) //字体大小
        }
    }
}


struct StListView_Previews: PreviewProvider {
    static var previews: some View {
        StListView(
            stData:[], vercode: "vercode??")
    }
}
