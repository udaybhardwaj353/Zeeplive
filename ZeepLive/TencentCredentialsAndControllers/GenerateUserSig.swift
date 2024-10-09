//
//  GenerateUserSig.swift
//  TencantOneToOneChat
//
//  Created by Creative Frenzy on 09/08/23.
//

import Foundation
import CommonCrypto
import zlib

class GenerateTestUserSig {
    
    static let SDKAPPID = GenerateTestUserSig.currentSDKAppid()
    static let SECRETKEY = GenerateTestUserSig.currentSecretkey()
    
    static let public_SDKAPPID: Int32 = 50000133
    static let EXPIRETIME: Int32 = 604800
    
    static let public_SECRETKEY = "285ca3020f5b2959ac564e26ff10ac884c13e2cfe890050e0ac992343024d25b"
    
    static func currentSDKAppid() -> UInt {
        return UInt(public_SDKAPPID)
    }
    
    static func currentSecretkey() -> String {
        return public_SECRETKEY
    }
    
    static func genTestUserSig(identifier: String) -> String {
        let current = CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970
        let TLSTime = Int(floor(current))
        var obj: [String: Any] = [
            "TLS.ver": "2.0",
            "TLS.identifier": identifier,
            "TLS.sdkappid": public_SDKAPPID,
            "TLS.expire": EXPIRETIME,
            "TLS.time": TLSTime
        ]
        var stringToSign = ""
        let keyOrder = [
            "TLS.identifier",
            "TLS.sdkappid",
            "TLS.time",
            "TLS.expire"
        ]
        for key in keyOrder {
            stringToSign += "\(key):\(obj[key]!)\n"
        }
        print(stringToSign)
        let sig = hmac(plainText: stringToSign)
        
        obj["TLS.sig"] = sig
        print("sig: \(sig)")
        do {
            let jsonToZipData = try JSONSerialization.data(withJSONObject: obj)
            var destLen = compressBound(UInt(jsonToZipData.count))
            let dest = UnsafeMutablePointer<Bytef>.allocate(capacity: Int(destLen))
            defer {
                dest.deallocate()
            }
            let ret = jsonToZipData.withUnsafeBytes { (srcPtr: UnsafeRawBufferPointer) -> Int32 in
                return compress2(dest, &destLen, srcPtr.bindMemory(to: Bytef.self).baseAddress, uLong(jsonToZipData.count), Z_BEST_SPEED)
            }
            if ret != Z_OK {
                print("[Error] Compress Error \(ret), upper bound: \(destLen)")
                return ""
            }
            let result = base64URL(data: Data(bytesNoCopy: dest, count: Int(destLen), deallocator: .none))
            return result
        } catch {
            print("[Error] json serialization failed: \(error)")
            return ""
        }
    }
    
    static func hmac(plainText: String) -> String {
        guard let cKey = public_SECRETKEY.cString(using: .ascii),
              let cData = plainText.cString(using: .ascii) else {
            return ""
        }

        var cHMAC = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))

        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, Int(strlen(cKey)), cData, Int(strlen(cData)), &cHMAC)

        let HMACData = Data(bytes: cHMAC, count: Int(CC_SHA256_DIGEST_LENGTH))
        return HMACData.base64EncodedString()
    }
    
    static func base64URL(data: Data) -> String {
        let result = data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "*")
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: "=", with: "_")
        
        return result
    }
}

