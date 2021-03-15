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

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        DataManager.shared.setup()
    }
}
