//
//  MapOverlay.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/12.
//

import SwiftUI

struct MapOverlay: View {
    @ObservedObject var summary: StatusSummary

    private var displayDuration: String {
        if summary.duration > 60 {
            return String(format: "%.1f\u{2009}分钟", summary.duration / 60.0)
        } else {
            return String(format: "%.0f\u{2009}秒", summary.duration)
        }
    }

    private var displayDistance: String {
        if summary.distance > 1000 {
            return String(format: "%.1f\u{2009}千米", Double(summary.distance) / 1000.0)
        } else {
            return String(format: "%d\u{2009}米", summary.distance)
        }
    }

    private var displayPastTime: String {
        if summary.pastDurationFromLatestUpdate > 60 {
            return String(format: "%.1f\u{2009}分钟前更新", summary.pastDurationFromLatestUpdate / 60.0)
        } else {
            return String(format: "%.0f\u{2009}秒前更新", summary.pastDurationFromLatestUpdate)
        }
    }

    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.6),
                                                   Color.black.opacity(0)]),
                       startPoint: .top,
                       endPoint: .center)
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle().fill(gradient)

            VStack(alignment: .leading) {
                Text(String(format: "⏳\u{2009}预计\u{2009}%@，%@", displayDuration, displayDistance))
                    .bold()
                    .padding([.leading, .top, .trailing])
                Text(displayPastTime)
                    .font(.footnote)
                    .padding(.leading, 13)
                    .padding(.top, 2)
            }
        }
        .foregroundColor(.white)
    }
}

struct MapOverlay_Previews: PreviewProvider {
    static var previews: some View {
        MapOverlay(summary: StatusSummary(stationInfo: (lineID: "1553", stationName: "地铁公益西桥站", indexInLine: 25))).background(Color.white)
    }
}
