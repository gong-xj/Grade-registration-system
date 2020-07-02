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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.res)
        }
    }
}

struct StListView_Previews: PreviewProvider {
    static var previews: some View {
        StListView(res: "res??:StList ")
    }
}
