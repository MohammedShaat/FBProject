//
//  Array+Chuncks.swift
//  FBProject
//
//  Created by Mohammed on 7/28/26.
//

import Foundation

extension Array {
    func chuncks(size: Int) -> [[Element]] {
        guard count > 0 else { return [self] }
        
        var chuncks: [[Element]] = []
        let chunksCount = (count + size - 1) / size
        for i in 0..<chunksCount {
            let start = size * i
            let end = Swift.min(start + size, count)
            let chunck = self[start..<end]
            chuncks.append(Array(chunck))
        }
        
        return chuncks
    }
}


import Playgrounds
#Playground {
    let array: [Int] = Array((1...62))
    _ = array.chuncks(size: 30)
}
