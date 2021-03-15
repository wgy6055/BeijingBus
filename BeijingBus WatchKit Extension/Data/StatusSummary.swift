//
//  StatusSummary.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/15.
//

import Foundation

class StatusSummary: ObservableObject {

    @Published var duration: TimeInterval = 0
    @Published var distance: Int = 0
    @Published var pastDurationFromLatestUpdate: TimeInterval = 0

    private var timer: Timer?
    private var latestUpdateTime: Date? {
        didSet {
            pastDurationFromLatestUpdate = 0
        }
    }
    let stationInfo: (lineID: String, stationName: String, indexInLine: Int)

    init(stationInfo: (lineID: String, stationName: String, indexInLine: Int)) {
        self.stationInfo = stationInfo
    }

    public func startUpdate() {
        let timer = Timer.scheduledTimer(withTimeInterval: 10,
                                     repeats: true) { (_) in
            self.refreshIfNeeded()
        }
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
        self.timer = timer
    }

    public func stopUpdate() {
        timer?.invalidate()
        timer = nil
    }

    private func refreshIfNeeded() {
        if let latestUpdateTime = latestUpdateTime {
            pastDurationFromLatestUpdate = latestUpdateTime.distance(to: Date())
        } else {
            pastDurationFromLatestUpdate = 0
        }
        if pastDurationFromLatestUpdate < 30 && pastDurationFromLatestUpdate > 0 {
            return
        }
        BeijingBusAPI.RealTime.getLineStatusForStation(lineID: stationInfo.lineID,
                                                       stationName: stationInfo.stationName,
                                                       indexInLine: stationInfo.indexInLine) { (status, _) in
            guard let status = status else { return }
            self.duration = status.estimatedRunDuration
            self.distance = status.distanceRemain
            self.latestUpdateTime = Date()
        }
    }
}
