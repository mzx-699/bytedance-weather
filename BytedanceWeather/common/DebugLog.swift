//
//  DebugLog.swift
//  SmartLawnMower
//
//  Created by 麻志翔 on 2021/12/15.
//

import Foundation


func delog(filePath: String = #file, rowCount: Int = #line) {
#if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print(fileName + "/" + "\(rowCount)" + "\n")
#endif
}

func delog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
#if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print(fileName + "/" + "\(rowCount)" + " \(message)" + "\n")
#endif
}
