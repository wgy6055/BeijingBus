//
//  DetailView.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/3.
//

import SwiftUI

struct DetailView: View {

    struct Station: Identifiable, Equatable {
        var id: UUID
        var name: String = ""
    }

//    private let lineNumber: String
    @State private var isForward = true
    @State private var startStation = ""
    @State private var endStation = ""
    @State private var stations: [Station] = []
    @State private var currentLineDetail: LineDetail?
    @State private var exchangeEnabled = true
    private let lineMetas: (forward: LineMeta, backward: LineMeta)?

    @State private var selectedUUID: UUID?

    init(lineNumber: String) {
        self.lineMetas = DataManager.shared.lineMetas(from: lineNumber)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
            VStack(spacing:0) {
                TerminalCell(startStation: $startStation,
                             endStation: $endStation,
                             exchangeEnabled: $exchangeEnabled) { refresh() }

                Spacer(minLength: 10)

                Divider()

                Spacer(minLength: 10)

                ForEach(stations) { station in
                    ZStack {
                        StationCell(name: station.name, type: type(from: station))
                            .frame(height: 50.0)
                            .onTapGesture { selectedUUID = station.id }

                        if let selectedStation = currentLineDetail?.stations.first { station.id == $0.uuid },
                           let lineDetail = currentLineDetail {
                            NavigationLink(
                                destination: MapView(lineDetail: lineDetail, station: selectedStation),
                                tag: station.id,
                                selection: $selectedUUID) { EmptyView() }
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .onLoad {
            refresh()
        }
    }

    private func refresh() {
        let lineID: String?
        if isForward {
            lineID = lineMetas?.forward.ID
        } else {
            lineID = lineMetas?.backward.ID
        }
        guard let lineId = lineID else { return }
        exchangeEnabled = false
        BeijingBusAPI.Static.getLineDetail(ofLine: lineId) { (lineDetail, _) in
            exchangeEnabled = true
            guard let lineDetail = lineDetail else {
                return
            }
            stations = lineDetail.stations.map { Station(id: $0.uuid,
                                                         name: $0.name) }
            currentLineDetail = lineDetail
            startStation = stations.first?.name ?? ""
            endStation = stations.last?.name ?? ""
            isForward.toggle()
        }
    }
    
    private func type(from station: Station) -> StationCell.PositionType {
        switch station {
        case stations.first:
            return .top
        case stations.last:
            return .bottom
        default:
            return .normal
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(lineNumber: "996")
    }
}
