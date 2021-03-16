//
//  HostingController.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/2/24.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<LineNumberPickerView> {
    override var body: LineNumberPickerView {
        LineNumberPickerView()
    }
}
