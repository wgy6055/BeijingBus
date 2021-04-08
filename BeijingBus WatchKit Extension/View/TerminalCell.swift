//
//  TerminalCell.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/10.
//

import SwiftUI

struct TerminalCell: View {

    var startStation: String
    var endStation: String
    @Binding var exchangeEnabled: Bool

    var refreshHandler: () -> Void = {}

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("🏁 " + startStation).lineLimit(1)
                Spacer()
                Text("🏁 " + endStation).lineLimit(1)
            }

            Spacer()

            Button(action: refreshHandler) {
                Image("exchange")
                    .resizable()
                    .frame(width: 20.0, height: 20.0)
            }
            .frame(width: 44.0, height: 44.0)
            .allowsHitTesting(exchangeEnabled)
        }
    }
}

struct TerminalCell_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TerminalCell(startStation: "首开广场",
                         endStation: "望京 SOHO",
                         exchangeEnabled: .constant(true))
        }
    }
}
