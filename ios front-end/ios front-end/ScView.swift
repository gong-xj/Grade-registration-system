//
//  ScView.swift
//  ios front-end
//
//  Created by Gongxinjie on 2020/07/02.
//  Copyright © 2020 Gongxinjie. All rights reserved.
//

import SwiftUI

struct ScView: View {
    @State var res: String
//    @State var stOrTe: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.res)
        }
    }
}

struct ScView_Previews: PreviewProvider {
    static var previews: some View {
        ScView(res: "res??:sc")
    }
}
