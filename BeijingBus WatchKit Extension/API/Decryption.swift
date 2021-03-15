//
//  Decryption.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/2/25.
//

import Foundation
import CommonCrypto

class Decryption {

    let rc4: RC4

    init(key:String) {
        let key = ("aibang" + key).md5
        rc4 = RC4(key: key)
    }

    func decode(string: String) -> String {
        guard let data = Data(base64Encoded: string) else {
            return string
        }
        let inputBytes: [UInt8] = Array(data)
        let bytes = rc4.encrypt(content: inputBytes)
        return String(bytes: bytes, encoding: .utf8) ?? string
    }
}
