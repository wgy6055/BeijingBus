//
//  StationCell.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/10.
//

import SwiftUI

struct StationCell: View {

    enum PositionType {
        case top
        case normal
        case bottom
    }

    var name: String
    var type: PositionType

    var body: some View {
        HStack {
            ZStack {
                VStack {
                    Rectangle()
                        .frame(width: 10.0)
                        .foregroundColor(type == .top
                                            ? .clear
                                            : Color(rgbValue: 0x00ced1))
                    Rectangle()
                        .frame(width: 10.0)
                        .foregroundColor(type == .bottom
                                            ? .clear
                                            : Color(rgbValue: 0x00ced1))
                }

                Circle()
                    .frame(width: 20.0)
                    .foregroundColor(Color(rgbValue: 0xffffff))
                    .overlay(Circle().stroke(Color(rgbValue: 0x00ced1), lineWidth: 4))
            }

            Spacer()

            Text(name)
                .lineLimit(1)

            Spacer()
        }
        .padding([.leading, .trailing], 10.0)
    }
}

struct StationCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            StationCell(name: "首开广场", type: .top)
                .frame(height: 50.0)
            StationCell(name: "望京 SOHO", type: .normal)
                .frame(height: 50.0)
        }
    }
}
