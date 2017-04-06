//
//  FREncrypter.swift
//  FolioReaderKit
//
//  Created by Alexandre Sagette on 06/04/2017.
//  Copyright © 2017 FolioReader. All rights reserved.
//

import Foundation
import CommonCrypto

class FREncrypter: NSObject
{
	/// Singleton instance
	open static let shared = FREncrypter()
	fileprivate override init() {}

	///
	func deobfuscate(path atPath: String, method withMethod: String)
	{
		debugPrint("deobfuscation of item at path : \(atPath) \n\twith method : \(withMethod)")
		let deofuscationKey = "urn:uuid:29d919dd-24f5-4384-be78-b447c9dc299b"

		/*
		1. get the font data
		2. get the obfuscation key
		3. strips the whitespace and applies SHA1 hash on the key
		4. apply deobfuscating algorithm
		*/
		do {
			let fontData = try Data(contentsOf: URL(fileURLWithPath: atPath), options: .alwaysMapped)
			let trimmedDeofuscationKey = deofuscationKey.trimmingCharacters(in: .whitespaces)
			let hasheddeofuscationKey = sha1(trimmedDeofuscationKey)

			debugPrint("deofuscationKey: \(deofuscationKey)")
			debugPrint("hasheddeofuscationKey: \(hasheddeofuscationKey)")
		}
		catch {

		}
	}

	func sha1(_ key: String) -> String {
		let data = key.data(using: String.Encoding.utf8)!
		var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
		data.withUnsafeBytes {
			_ = CC_SHA1($0, CC_LONG(data.count), &digest)
		}
		let hexBytes = digest.map { String(format: "%02hhx", $0) }
		return hexBytes.joined()
	}
}
