//
//  Resource+Color.swift
//  
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit

public extension Resource {
    enum Color {
        // MARK: - GrayScale
        public static let white = UIColor(named: "white", in: .module, compatibleWith: nil)!
        public static let gray100 = UIColor(named: "gray100", in: .module, compatibleWith: nil)!
        public static let gray400 = UIColor(named: "gray400", in: .module, compatibleWith: nil)!
        public static let black = UIColor(named: "black", in: .module, compatibleWith: nil)!
        
        // MARK: - Red
        public static let red100 = UIColor(named: "red100", in: .module, compatibleWith: nil)!
        
        // MARK: - Blue
        public static let blue100 = UIColor(named: "blue100", in: .module, compatibleWith: nil)!
        
        // MARK: - Semantic
        public static let borderLine = gray100
    }
}
