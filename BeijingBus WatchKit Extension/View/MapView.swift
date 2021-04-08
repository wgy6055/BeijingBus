//
//  MapView.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/10.
//

import SwiftUI
import MapKit

struct MapView: View {

    private struct Point: Identifiable {
        var id = UUID()
        var location: CLLocationCoordinate2D
    }

    private let region: MKCoordinateRegion
    private let station: Point
    private var summary: StatusSummary

    init(lineDetail: LineDetail, station: LineDetail.Station) {
        self.station = Point(location: station.location.CLCoordinate2D)
        region = MKCoordinateRegion(center: station.location.CLCoordinate2D,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                           longitudeDelta: 0.01))
        summary = StatusSummary(stationInfo: (lineDetail.ID, station.name, station.index))
    }

    var body: some View {
        Map(coordinateRegion: .constant(region),
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow),
            annotationItems: [station]) { MapPin(coordinate: $0.location) }
            .overlay(MapOverlay(summary: summary))
            .onAppear {
                summary.startUpdate()
            }
            .onDisappear {
                summary.stopUpdate()
            }
    }
}

//struct MapView_Preview: PreviewProvider {
//    static var previews: some View {
//        MapView(lineDetail: LineDetail(JSON: [:]), station: LineDetail.Station(name: "",
//                                            index: 0,
//                                            location: Coordinate(longitude: 51,
//                                                                 latitude: 116)))
//    }
//}
