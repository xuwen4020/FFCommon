//
//  Date+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Date {
    ///秒级时间戳
    var timeStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int64(timeInterval)
        return timeStamp
    }
    ///毫秒级时间戳
    var milliStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return Int64(millisecond)
    }
    
    ///微秒级时间戳
    var microsecondsStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000000))
        return Int64(millisecond)
    }
    
    ///纳秒级时间戳
    var nanosecondStamp : Int64 {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let nanosecond = CLongLong(round(timeInterval*1000000000))
        return Int64(nanosecond)
    }
    ///秒级时间戳
    var timeStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String(timeStamp)
    }
    ///毫秒级时间戳
    var milliStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return String(Int(millisecond))
    }
    ///微秒级时间戳
    var microsecondsStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000000))
        return String(Int(millisecond))
    }
    ///纳秒级时间戳
    var nanosecondStampString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let nanosecond = CLongLong(round(timeInterval*1000000000))
        return String(nanosecond)
    }
    
    //是否为今天
    var isToday: Bool {
        let date = Date()
        if self.toString(format: "yyyyMMdd") == date.toString(format: "yyyyMMdd") {
            return true
        }
        return false
    }
    
    /// 是否为昨天
    var isYesterday: Bool {
        // 1.先拿到昨天的 date
        guard let yesterDate = Date().adding(day: -1) else {
            return false
        }
        // 2.比较当前的日期和昨天的日期
        return isSameYeaerMountDay(yesterDate)
    }

    /// 是否为今年
    var isThisYear: Bool  {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    
    /// 是否为  同一年  同一月 同一天
    /// - Returns: bool
    var isSameYearMonthDayWithToday: Bool {
        return isSameYeaerMountDay(Date())
    }

    /// 日期的加减操作
    /// - Parameter day: 天数变化
    /// - Returns: date
    func adding(day: Int) -> Date? {
        return Calendar.current.date(byAdding: DateComponents(day:day), to: self)
    }

    /// 是否为  同一年  同一月 同一天
    /// - Parameter date: date
    /// - Returns: 返回bool
    private func isSameYeaerMountDay(_ date: Date) -> Bool {
        let com = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let comToday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return (com.day == comToday.day &&
            com.month == comToday.month &&
        com.year == comToday.year )
    }
    
    enum StampFormat: String {
        case normal = "HH:mm:ss"
        case chinese = "HH小时mm分钟ss秒"
    }
    // MARK: - 把秒数转换成时分秒（00:00:00）格式
    /// 把秒数转换成时分秒（00:00:00）格式
    static func timeStampToString(timeStamp: Int, format: StampFormat = .normal, auto: Bool = false) -> String {
        var timeString = ""
        
        // 天
        let days = Int(timeStamp/(3600*24))
        // 时
        let hours = Int((timeStamp - days*24*3600)/3600)
        // 分
        let minute = Int((timeStamp - days*24*3600-hours*3600)/60)
        // 秒
        let second = Int((timeStamp - days*24*3600-hours*3600) - 60*minute)

        switch format {
        case .normal:
            if auto == true {
                if hours > 0 {
                    timeString += String.init(format: "%02d",hours)
                    if minute > 0 {
                        timeString += String.init(format: ":%02d",minute)
                    }
                    if second > 0 {
                        timeString += String.init(format: ":%02d",second)
                    }
                    return timeString
                }
                if minute > 0 {
                    timeString += String.init(format: "%02d",minute)
                    if second > 0 {
                        timeString += String.init(format: ":02%d",second)
                    }
                    return timeString
                }
                if second > 0 {
                    timeString = String.init(format: "00:%02d",second)
                    return timeString
                }
            } else {
                timeString = String.init(format: "%02d:%02d:%02d",hours,minute,second)
            }
        case .chinese:
            if auto == true {
                if hours > 0 {
                    timeString += String.init(format: "%d小时",hours)
                    if minute > 0 {
                        timeString += String.init(format: "%d分钟",minute)
                    } else {
                        if second > 0 {
                            timeString += String.init(format: "%d秒",second)
                        }
                    }
                    return timeString
                }
                if minute > 0 {
                    timeString += String.init(format: "%d分钟",minute)
                    if second > 0 {
                        timeString += String.init(format: "%d秒",second)
                    }
                    return timeString
                }
                if second > 0 {
                    timeString = String.init(format: "%d秒",second)
                    return timeString
                }
            } else {
                timeString = String.init(format: "%d小时%d分钟%d秒",hours,minute,second)
            }
        }
       return timeString
   }
    
    /// 时间戳转字符串
    /// - Parameter time: 时间戳
    /// - Returns: 字符串
    static func setupDateString<T>(time: T) -> String {
        
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy MM dd HH:mm:ss"
        fmt.locale = NSLocale(localeIdentifier: "zh_Hans_CN") as Locale
        
        var createAtstr: String?
        
        if T.self == Double.self {
            let date = Date(timeIntervalSince1970: (time as! Double))
            createAtstr = fmt.string(from: date)
        }
        else if T.self == Int64.self {
            let date = Date(timeIntervalSince1970: Double(time as! Int64))
            createAtstr = fmt.string(from: date)
        }
        else {
            let date = fmt.date(from: time as! String)
            createAtstr = fmt.string(from: date!)
        }
        
        guard let ceateDate = fmt.date(from: createAtstr!) else { return "" }
        
        let interval = Date().timeIntervalSince(ceateDate)
        
        if !ceateDate.isThisYear {
            fmt.dateFormat = "yyyy年MM月dd日"
            return fmt.string(from: ceateDate)
        }
        
        if interval < 60 { return "刚刚"  }
        
        if interval < 3600 { return "\(Int((interval/60)))分钟前" }
        
        if interval < 3600*24 { return "\(Int((interval/(3600))))小时前" }
        fmt.dateFormat = "MM月dd日"
        return fmt.string(from: ceateDate)
    }
    
    /// 时间装字符串
    func format(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss", LocalId: String = "zh_CN") -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: LocalId)
        df.dateFormat = dateFormat
        let str = df.string(from: self)
        return str
    }
    
    /// MARK:- 格式转换
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    static func timeIntervalToString(time: Int64,format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(time)/1000)
        return date.toString(format: format)
    }
    
    //根据身份证获取出生日期
    static func birthdayStrFromIdentityCard(numberStr: String) -> (String) {
        var year:String = ""
        var month:String
        var day:String
        //截取前14位
//        let fontNumber = (numberStr as NSString).substringWithRange(NSMakeRange(0, 14))
        //判断是18位身份证还是15位身份证
        if (numberStr as NSString).length == 18 {
            year = numberStr.subString(start: 6, length: 4)
            month = numberStr.subString(start: 10, length: 2)
            day = numberStr.subString(start: 12, length: 2)
            let result = "\(year)-\(month)-\(day)"
            print(result)
            return result
        }else{
            year = numberStr.subString(start: 6, length: 2)
            month = numberStr.subString(start: 8, length: 2)
            day = numberStr.subString(start: 10, length: 2)
            let result = "19\(year)-\(month)-\(day)"
            print(result)
            return result
        }
    }
    
    //根据出生日期计算年龄的方法
    static func caculateAge(birthday: Int64) -> Int{
        
        //格式化日期
        let birthDay_date = Date.init(timeIntervalSince1970: TimeInterval(birthday))
        let birthdayDate = Calendar.current.dateComponents([.year, .month, .day], from: birthDay_date)
        let brithDateYear  = birthdayDate.year ?? 0
        let brithDateDay   = birthdayDate.day ?? 0
        let brithDateMonth = birthdayDate.month ?? 0
        // 获取系统当前 年月日
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let currentDateYear  = currentDate.year ?? 0
        let currentDateDay   = currentDate.day ?? 0
        let currentDateMonth = currentDate.month ?? 0
        // 计算年龄
        var iAge = currentDateYear - brithDateYear - 1
        if iAge <= 0 {
            iAge = 1
        }
        if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
            iAge += 1
        }
        return iAge
    }
}

