//
//  FileIOManager.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

import Foundation
struct FileIOManager {
    private static let directoryName:String = "EmployeeImages"
    var manager = FileManager.default
    var employeeImagesFolderURL: URL?
    
    init() throws {
        let rootFolderURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        employeeImagesFolderURL = rootFolderURL.appendingPathComponent(FileIOManager.directoryName)
        
        do {
            guard let employeeImagesFolderURL = employeeImagesFolderURL else {
                throw NSError(domain: "employeeImagesFolderURL cannot be nil", code: 0)
            }
            if !manager.fileExists(atPath: employeeImagesFolderURL.relativePath) {
                try manager.createDirectory(
                    at: employeeImagesFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            }
        } catch CocoaError.fileWriteFileExists {
            // Folder already existed
        } catch {
            throw error
        }
        
    }
    func read(
        documentName: String
    ) throws -> URL?{
        guard let employeeImagesFolderURL = employeeImagesFolderURL else {
            throw NSError(domain: "employeeImagesFolderURL cannot be nil", code: 0)
        }
        let urlPath = employeeImagesFolderURL.appendingPathComponent(documentName)
        if manager.fileExists(atPath: urlPath.relativePath) {
            return urlPath
        }else{
            return nil
        }
    }
    func write<T: Encodable>(
        _ object: T,
        documentName: String,
        encodedUsing encoder: JSONEncoder = .init()
    ) throws -> URL {
        guard let employeeImagesFolderURL = employeeImagesFolderURL else {
            throw NSError(domain: "employeeImagesFolderURL cannot be nil", code: 0)
        }
        let fileURL = employeeImagesFolderURL.appendingPathComponent(documentName)
        let data = try encoder.encode(object)
        try data.write(to: fileURL)
        return fileURL
    }
    func move(
        fromURL: URL,
        documentName: String
    ) throws -> URL? {
        guard let employeeImagesFolderURL = employeeImagesFolderURL else {
            throw NSError(domain: "employeeImagesFolderURL cannot be nil", code: 0)
        }
        guard manager.fileExists(atPath: fromURL.path) && manager.fileExists(atPath: employeeImagesFolderURL.path) else{
            return nil
        }
        let fileURL = employeeImagesFolderURL.appendingPathComponent(documentName)
        do{
            try manager.moveItem(atPath: fromURL.path, toPath: fileURL.path)
        }catch {
            print("Unexpected error: \(error).")
        }
        return fileURL
    }
}
