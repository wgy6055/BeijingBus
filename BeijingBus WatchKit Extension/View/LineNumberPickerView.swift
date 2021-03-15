//
//  LineNumberPickerView.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/2/24.
//

import SwiftUI

struct LineNumberPickerView: View {

    private let numbers: [Int] = {
        (0...9).map { Int($0) }
    }()
    @State private var selectedIndex0 = 0.0
    @State private var selectedIndex1 = 0.0
    @State private var selectedIndex2 = 0.0
    private var lineNumber: String {
        String(numbers[Int(selectedIndex2)] * 100 + numbers[Int(selectedIndex1)] * 10 + numbers[Int(selectedIndex0)])
    }

    @State private var flag = false

    var body: some View {
        NavigationView(content: {
            VStack() {
                Spacer()
                Text("🚌 请选择公交线路").font(.title3)
                Spacer()
                HStack() {
                    Picker("", selection: $selectedIndex2) {
                        ForEach((0 ..< numbers.count)) {
                            Text(String(numbers[$0])).foregroundColor(Color(rgbValue: 0x00ced1)).tag(Double($0)).font(.title)
                        }
                    }
                    .frame(width: 50.0, height: 70.0)
                    Picker("", selection: $selectedIndex1) {
                        ForEach((0 ..< numbers.count)) {
                            Text(String(numbers[$0])).foregroundColor(Color(rgbValue: 0x00ced1)).tag(Double($0)).font(.title)
                        }
                    }
                    .frame(width: 50.0, height: 70.0)
                    Picker("", selection: $selectedIndex0) {
                        ForEach((0 ..< numbers.count)) {
                            Text(String(numbers[$0])).foregroundColor(Color(rgbValue: 0x00ced1)).tag(Double($0)).font(.title)
                        }
                    }
                    .frame(width: 50.0, height: 70.0)
                }
                Spacer(minLength: 30)
                NavigationLink(destination: DetailView(lineNumber: lineNumber)) { Text("查询") }
            }
        })
    }
}

struct LineNumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        LineNumberPickerView()
    }
}
