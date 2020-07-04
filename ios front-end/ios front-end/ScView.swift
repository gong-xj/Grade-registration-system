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
        VStack(alignment: .leading) {
//            Text("hello你大爷")
            List(scData) { sc in
                Text(sc.nameAndScore)
//                Text("111")
            }
        }
    }
}

struct ScView_Previews: PreviewProvider {
    static var previews: some View {
        ScView(scData: [])
    }
}
