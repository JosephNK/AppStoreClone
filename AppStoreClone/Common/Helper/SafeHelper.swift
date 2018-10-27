//
//  SafeHelper.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 24..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

extension Collection {
    
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
    
}

extension NSNumber {
    
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
    
}

extension KeyedDecodingContainer {
    
    func decodeSafe<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T? {
        let value = try? self.decode(T.self, forKey: key)
        
        if value != nil {
            return value
        }
        
        if let value = try? self.decode(String.self, forKey: key) {
            if T.self is Int.Type {
                return Int(value.isEmpty ? "0" : value) as? T
            } else if T.self is Int64.Type {
                return Int64(value.isEmpty ? "0" : value) as? T
            } else if T.self is Double.Type {
                return Double(value.isEmpty ? "0.0" : value) as? T
            } else if T.self is Float.Type {
                return Float(value.isEmpty ? "0.0" : value) as? T
            }
        }
        
        return nil
    }
    
    func decodeInt64(forKey key: KeyedDecodingContainer.Key) throws -> Int64 {
        if let value = try? self.decode(String.self, forKey: key) {
            return Int64(value.isEmpty ? "0" : value)!
        } else if let value = try? self.decode(Int64.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Int64(value)
        }
        return 0
    }
    
    func decodeDouble(forKey key: KeyedDecodingContainer.Key) throws -> Double {
        if let value = try? self.decode(String.self, forKey: key) {
            return Double(value.isEmpty ? "0.0" : value)!
        } else if let value = try? self.decode(Int.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Double(value)
        }
        return 0.0
    }
    
}
