//
//  BeijingBusAPI.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/2/24.
//

import Foundation
import ObjectMapper

struct BeijingBusAPI {
    struct Static {
        public static func getAllLines(completion: @escaping ([LineMeta]?, Error?) -> Void) {
            requestAPI(path: "ssgj/v1.0.0/checkUpdate?version=1", additionalHeaders: [
                "PID": "5",
                "PLATFORM": "ios",
                "CID":"18d31a75a568b1e9fab8e410d398f981",
                "TIME": "1539706356",
                "ABTOKEN": "31d7dae1d869a172f3b66fa14fe274d1",

                "VID": "6",
                "IMEI": "\(arc4random_uniform(10000)+1)",
                "CTYPE": "json",
            ]) { (JSONObject, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let JSONObject = JSONObject else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let root = JSONObject["lines"] as? [String : Any],
                      let data = root["line"] as? [[String : Any]] else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                let lines = data.compactMap { json -> LineMeta? in
                    guard let status = json["status"] as? String,
                          status == "0" else { return nil }
                    return Mapper<LineMeta>().map(JSON: json)
                }
                DispatchQueue.main.async {
                    completion(lines, error)
                }
            }
        }

        public static func getLineDetail(ofLine lineID: String, completion: @escaping (LineDetail?, Error?) -> Void) {
            requestAPI(path: "ssgj/v1.0.0/update?id=\(lineID)", additionalHeaders: [
                "PID": "5",
                "PLATFORM": "ios",
                "CID":"18d31a75a568b1e9fab8e410d398f981",
                "TIME": "1540031093",
                "ABTOKEN": "55750cf92a54b09bd52e23105f7f60aa",

                "VID": "6",
                "IMEI": "\(arc4random_uniform(10000)+1)",
                "CTYPE": "json",
            ]) { (JSONObject, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let JSONObject = JSONObject else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let busline = JSONObject["busline"] as? [[String : Any]] else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                let lineDetail = busline.first.map { dict -> LineDetail? in
                    return Mapper<LineDetail>().map(JSON: dict)
                } as? LineDetail
                DispatchQueue.main.async {
                    completion(lineDetail, error)
                }
            }
        }
    }

    struct RealTime {
        public static func getLineStatusForStation(lineID: String, stationName: String, indexInLine:Int, completion: @escaping (BusStatusForStation?, Error?) -> Void) {
            let query = String(format:"%@@@@%d@@@%@", lineID, indexInLine, stationName)
            requestAPI(path: "ssgj/bus2.php",
                       method: "POST", additionalHeaders: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"],
                       parameters: ["query": query]) { (JSONObject, error) in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let JSONObject = JSONObject else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let root = JSONObject["root"] as? [String: Any],
                      let data = root["data"] as? [String: Any],
                      let bus = data["bus"] as? [[String: Any]],
                      let json = bus.first else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                guard let status = Mapper<BusStatusForStation>().map(JSON: json) else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(status, nil)
                }
            }
        }
    }

    // MARK: - Private Method

    private static let baseURL = "http://transapp.btic.org.cn:8512/"
    private static func requestAPI(path: String,
                                   method: String = "GET",
                                   additionalHeaders: [String : String]? = nil,
                                   parameters:[String: Any]? = nil,
                                   completion: @escaping ([String : Any]?, Error?) -> Void) {
        var url = baseURL + path
        let beijing = "北京".addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        let additionalQuery = "city=\(beijing)&datatype=json"
        if url.contains("?") {
            url += ("&" + additionalQuery)
        } else {
            url += ("?" + additionalQuery)
        }
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        let body = parameters?.map({ (key, value) -> String in
            return "\(key)=\(value)"
        })
        .joined(separator: "&")
        .data(using: .utf8)
        request.httpBody = body
        additionalHeaders?.forEach { (key, value) in
            request.setValue(value,
                             forHTTPHeaderField: key)
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String : Any] else {
                completion(nil, error)
                return
            }
            completion(dict, error)
        }.resume()
    }
}
