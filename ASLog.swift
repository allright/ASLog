//
//  Log.swift
//  ASLog
//
//  Created by Andrey Syvrachev on 17.02.17.
//  Copyright © 2017 Andrey Syvrachev. All rights reserved.
//

import Foundation

public class ASLog: NSObject {
    public enum Level: Int, Comparable {
        case VBS
        case DBG
        case INF
        case WRN
        case ERR
        case SVR

        // Implement Comparable
        public static func < (a: Level, b: Level) -> Bool {
            return a.rawValue < b.rawValue
        }
    }
    
    public static var filterTags:[String]?
    public static var logLevel:Level = .DBG

    public static func log(_ level:Level, tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        guard logLevel <= level else { return }
        logv(level, tag:tag, format)
    }
    
    public static func svr(_ tag: @autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.SVR,tag:tag,format)
    }
    
    public static func inf(_ tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.INF,tag:tag,format)
    }
    
    public static func wrn(_ tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.INF,tag:tag,format)
    }
    
    public static func err(_ tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.ERR,tag:tag,format)
    }
    
    public static func dbg(_ tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.DBG,tag:tag,format)
    }
    
    public static func vbs(_ tag:@autoclosure () -> String, _ format: @autoclosure () -> String) {
        log(.VBS,tag:tag,format)
    }
}

extension ASLog {
    static fileprivate func logv(_ level:Level, tag:@autoclosure () -> String, _ format: @autoclosure () -> String){
        let tg = tag()
        guard acceptTag(tg) else { return }

        let sQueue = currentQueueName()
        let sTag = Format.apply(formatter: Format.tag, str: tg)
        
        objc_sync_enter(self)
        NSLog("\(level)\(sQueue)\(sTag) > \(format())")
        objc_sync_exit(self)
    }
    
    static fileprivate func currentQueueName() -> String {
        let name = __dispatch_queue_get_label(nil)
        guard let str = String(cString: name, encoding: .utf8) else { return ""}
        return Format.apply(formatter: Format.queue, str: str)
    }
    
    static fileprivate func acceptTag(_ tag:String) -> Bool {
        guard let tags = filterTags else { return true }
        guard tag.count > 0 else { return false }
        for filter in tags {
            if tag == filter {
                return true
            }
        }
        return false
    }
}

extension String {
    fileprivate func stringByLeftPaddingTo(length newLength : Int) -> String {
        let length = self.count
        if length <= newLength {
            return String(repeating: " ", count: newLength - length) + self
        } else {
            let beg = self.index(endIndex, offsetBy: -newLength + 2)
            return "..".appending(self[beg...])
        }
    }
}

extension ASLog {
    public class Format {
        public typealias Formatter = ((String)->String)
        
        static public func rightAllign(lenght: Int) -> Formatter {
            return { name in
                guard let str = String(cString: name, encoding: .utf8) else { return ""}
                return str.stringByLeftPaddingTo(length: lenght)
            }
        }
        
        static public var queue:Formatter?
        static public var tag:Formatter?
        
        static fileprivate func apply(formatter:Formatter?,str:String) -> String {
            func wrap(_ s:String) -> String { return s.count > 0 ? " [\(s)]" : "" }
            guard let f = formatter else { return wrap(str) }
            return wrap(f(str))
        }
    }
}
