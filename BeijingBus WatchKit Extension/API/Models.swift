//
//  Models.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/2/24.
//

import Foundation
import ObjectMapper

public struct BusStatusForStation {

    public let ID: String
    public let lineID: String?
    public let timestamp: Double

    public let currentLocation: Coordinate
    public let gpsUpdatedTime: Double

    public let distanceRemain:Int
    public let estimatedRunDuration: TimeInterval
    public let estimatedArrivedTime: Double


    public let comingStation: (
        name:String,
        index:Int,
        distanceRemain:Int,                 // 距离下一站的距离
        estimatedRunDuration: TimeInterval, // 距离下一站还有几秒
        estimatedArrivedTime: Double        // 预计到达下一站的时间
    )

    public let delay: String  // 红绿灯延误时间
    public let type: String
}


public struct LineMeta {
    public let ID: String
    public let busNumber: String // 大部分为数字。对于运通路线，前面包含"运通"二字
    public let departureStationName: String
    public let terminalStationName: String

    public let classify: String // 线路分类，比较粗糙，没有什么实际意义
    public let status: String // unknow
    public let version: String // unknow
}


public struct LineDetail {

    public struct Station {
        public let uuid = UUID()
        public let name: String
        public let index: Int
        public let location: Coordinate
    }

    public let ID: String
    public let busNumber: String // 大部分为数字。对于运通路线，前面包含"运通"二字
    public let departureStationName: String
    public let terminalStationName: String
    public let operationTime: String
    public let stations: [Station]

    public let coords:String // 一些列坐标，这里面的坐标和 stations 里的坐标略有不同，不知道为什么
}

public struct Coordinate {
    public let longitude: Double
    public let latitude: Double
}

// MARK:- Codable

extension BusStatusForStation: ImmutableMappable {
    public init(map: Map) throws {
        ID = try map.value("id")
        lineID = try map.value("lid")
        timestamp = Double(try map.value("ut") as String) ?? -1

        let de = Decryption(key: try map.value("gt"))
        let currentLocationString = (
            longitude: de.decode(string: try map.value("x")) ,
            latitude: de.decode(string: try map.value("y"))
        )
        currentLocation = Coordinate(
            longitude: Double(currentLocationString.longitude) ?? -1,
            latitude: Double(currentLocationString.latitude) ?? -1
        )

        gpsUpdatedTime = Double(try map.value("gt") as String) ?? -1
        distanceRemain = Int(de.decode(string: try map.value("sd"))) ?? -1
        estimatedRunDuration = Double(de.decode(string:try map.value("srt"))) ?? -1
        estimatedArrivedTime = Double(de.decode(string: try map.value("st"))) ?? -1

        comingStation = (
            name: de.decode(string: try map.value("ns")),
            index: Int(de.decode(string: try map.value("nsn"))) ?? -1,
            distanceRemain: Int(try map.value("nsd") as String) ?? -1,
            estimatedRunDuration: TimeInterval(try map.value("nsrt") as String) ?? -1,
            estimatedArrivedTime: Double(try map.value("nst") as String) ?? -1
        )

        type = try map.value("t")
        delay = try map.value("lt")
    }
}

extension LineMeta: ImmutableMappable {
    public init(map: Map) throws {
        ID = try map.value("id")

        let name: String = try map.value("linename")
        let parsed = paresefullName(name)
        busNumber = parsed.lineNumber
        departureStationName = parsed.departureStationName
        terminalStationName = parsed.terminalStationName

        classify = try map.value("classify")
        version = try map.value("version")
        status = try map.value("status")
    }
}
extension LineDetail: ImmutableMappable {
    public init(map: Map) throws {
        ID = try map.value("lineid")
        let de = Decryption(key: ID)

        busNumber = de.decode(string: try map.value("shotname"))
        let parsed = paresefullName(de.decode(string: try map.value("linename")))
        departureStationName = parsed.departureStationName
        terminalStationName = parsed.terminalStationName
        operationTime = try map.value("time")

        stations = (try map.value("stations.station") as [[String: String]]).map { dict in
            let name = de.decode(string: dict["name"] ?? "")
            let index = Int(de.decode(string:  dict["no"] ?? "")) ?? -1
            let lon = Double(de.decode(string:  dict["lon"] ?? "") ) ?? -1
            let lat = Double(de.decode(string:  dict["lat"] ?? "") ) ?? -1
            return Station(name: name, index: index, location: Coordinate(longitude: lon, latitude: lat))
        }

        coords = de.decode(string: try map.value("coord"))
    }
}

private let busNameRegex = try! NSRegularExpression(pattern: "^(.+)\\((.+)\\-(.+)\\)$", options: [])
private func paresefullName(_ name:String) -> (lineNumber:String, departureStationName:String, terminalStationName: String) {
    if let match = busNameRegex.firstMatch(in: name, options: [], range: NSMakeRange(0, name.count)), match.numberOfRanges == 4 {
        let groups = (1...3).map { (i: Int) -> String in
            let range = match.range(at: i)
            return (name as NSString).substring(with: range)
        }
        return (groups[0], groups[1], groups[2])
    } else {
        return (name, "", "")
    }
}
