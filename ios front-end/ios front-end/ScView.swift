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
    @State var name: String
    
    
    var body: some View {
        VStack{
//            Spacer()
            Text(name)
            List(scData) { sc in
                Text(sc.nameAndScore)
            }
        }
    }
}

struct ScView_Previews: PreviewProvider {
    static var previews: some View {
        ScView(scData: [], name: "")
    }
}
