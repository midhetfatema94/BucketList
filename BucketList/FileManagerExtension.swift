//
//  FileManagerExtension.swift
//  BucketList
//
//  Created by Waveline Media on 12/29/20.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func writeToFile(write data: Data, fileName: String, options: Data.WritingOptions) {
        let url = self.getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            try data.write(to: url, options: options)
            let input = try String(contentsOf: url)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
    }
}
