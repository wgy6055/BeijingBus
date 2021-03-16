//
//  DataManager.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/4.
//

import Foundation

class DataManager {

    static let shared = DataManager()

    private var allLines: [LineMeta] = []
    private init() {}
    
    func setup() {
        BeijingBusAPI.Static.getAllLines { (lines, _) in
            guard let lines = lines else {
                return
            }
            self.allLines = lines
        }
    }
    
    func lineMetas(from busNumber: String) -> (forward: LineMeta, backward: LineMeta)? {
        let results = allLines.filter({ $0.busNumber == busNumber })
        guard results.count > 1 else {
            return nil
        }
        return (results[0], results[1])
    }
}
