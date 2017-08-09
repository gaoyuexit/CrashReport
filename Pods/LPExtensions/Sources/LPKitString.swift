//
//  LPKitString.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/10.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation
import LPExtensionsCommonCrypto


public extension String {
    
    func md5() -> String? {
        guard let messageData = data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func MD5OfFile(path: String) -> String? {
        let handle = FileHandle(forReadingAtPath: path)
        guard handle == nil else { return nil }
        
        var md5: CC_MD5_CTX = CC_MD5_CTX()
        CC_MD5_Init(&md5)
        
        var done = false
        
        while !done {
            let fileData = NSData(data: handle!.readData(ofLength: 4096))
            CC_MD5_Update(&md5, fileData.bytes, CC_LONG(fileData.length))
            
            if fileData.length == 0 {
                done = true
            }
        }
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5_Final(digest, &md5)
        let s = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15])
        return s
    }
    
    func sha1() -> String {
        let cstr = cString(using: .utf8)
        let data = NSData(bytes: cstr, length: characters.count)
        
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_SHA1(data.bytes, CC_LONG(data.length), digest)
        
        var output:String = ""
        
        for i in 0..<Int(CC_SHA1_DIGEST_LENGTH) {
            output.append(String(format: "%02x", digest[i]))
        }
        return output
    }
    
    // From Alamofire, Percent Encoding
    func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    /// String word count
    func countWords() -> Int {
        
        var wordCount = 0
        let range = startIndex ..< endIndex
        enumerateSubstrings(in: range, options: .byWords) { (string, _, _, _) in
            wordCount += 1
        }
        return wordCount
    }
    
    func strippingWhitespace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Camel to underscores
    func camelCaseToUnderscores() -> String {
        var string = ""
        let uppercase = CharacterSet.uppercaseLetters
        var count = 0
        for c in characters {
            count += 1
            if containsCharacter(c: c, uppercase: uppercase) {
                let str = count == 1 ? "" : "_"
                string.append(str + String(c).lowercased())
            } else {
                string.append(String(c))
            }
        }
        return string
    }
    /// UnderScore to camel
    func underscoresToCamelCase() -> String {
        var string = ""
        var makeNextCharacterUpperCase = false
        for c in characters {
            if String(c) == "_" {
                makeNextCharacterUpperCase = true
            } else if makeNextCharacterUpperCase {
                string.append(String(c).uppercased())
                makeNextCharacterUpperCase = false
            } else {
                string.append(c)
            }
        }
        return string
    }
    
    private func containsCharacter(c: Character, uppercase:CharacterSet) -> Bool {
        
        let s = String(c)
        let ix = s.startIndex
        let ix2 = s.endIndex
        let result = s.rangeOfCharacter(from: uppercase, options: [], range: ix..<ix2)
        return result != nil
    }
    
    /// String first word capital
    func capitalizeFirst() -> String {
        guard characters.count == 0 else { return self }
        
        let range = startIndex ..< index(startIndex, offsetBy: 1)
        let string = replacingCharacters(in: range, with: substring(to: index(startIndex, offsetBy: 1)).capitalized)
        
        return string
    }
    
    /// Whether the string is empty
    func isBlank() -> Bool {
        if strippingWhitespace() == "" {
            return true
        }
        return false
    }
    
    /// String time to date
    func timeDate(stringFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        let localZone = TimeZone(abbreviation: "CST")
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = stringFormat
        return dateFormatter.date(from: self)
    }
    
    /// Verify that it is a mobile phone number
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^1[3|4|5|7|8]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    /// Verify that it is a landline numbe
    func isValidTelNumber() -> Bool {
        let phoneRegex = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let isCommonTelPhone = phoneTest.evaluate(with: self)
        
        let servicePhoneRegex = "^(400|800)\\d{7}$"
        let servicePhoneTest = NSPredicate(format: "SELF MATCHES %@", servicePhoneRegex)
        let isServicePhone = servicePhoneTest.evaluate(with: self)
        
        return isCommonTelPhone || isServicePhone
    }
    
    /// Verify that it is a email
    func isEmail() -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return regExPredicate.evaluate(with: lowercased())
    }

    
    ///项目版本号
    static var projectVersion: String {
        return "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    }
    ///项目名称
    static var projectName: String {
        return Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
    }
}
