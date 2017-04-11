//
//  FREncrypter.swift
//  FolioReaderKit
//
//  Created by Alexandre Sagette on 06/04/2017.
//  Copyright © 2017 FolioReader. All rights reserved.
//

import Foundation
import Arcane
import CCommonCrypto

class FREncrypter: NSObject
{
	/// Singleton instance
	open static let shared = FREncrypter()
	fileprivate override init() {}

	///
	func deobfuscate(path atPath: String, method withMethod: String)
	{
		debugPrint("deobfuscation of item at path : \(atPath) \n\twith method : \(withMethod)")
		let epubUID = "urn:uuid:29d919dd-24f5-4384-be78-b447c9dc299b"

		/*
		1. get the font data
		2. get the obfuscation key
		3. strips the whitespace and applies SHA1 hash on the key
		4. apply deobfuscating algorithm
		*/
		do {
			let fontData = try Data(contentsOf: URL(fileURLWithPath: atPath), options: .alwaysMapped)

			if let mask = makeKey(epubUID: epubUID) {

				var buffer = [UInt8](repeating: 0, count: 4096)
				var first = true
				let inputStream = InputStream(data: fontData)
				let outpuStream = OutputStream(toFileAtPath: atPath, append: false)!

				while inputStream.hasBytesAvailable
				{
					let len = inputStream.read(&buffer, maxLength: buffer.count)

					if(len > 0)
					{
						if (first)
						{
							first = false
							for index in 0...1040 {
								buffer[index] = (buffer[index] ^ mask[index % mask.count]);
							}
						}
					}
					else {
						// it means inputStream.read return an -1 error code
						return
					}

					outpuStream.write(buffer, maxLength: len)
				}

			}
		}
		catch {
			debugPrint("error caught : \(error)")
		}
	}

	func makeKey(epubUID: String) -> Data!
	{
		let trimmedDeofuscationKey = epubUID.trimmingCharacters(in: .whitespaces)
		let hasheddeofuscationKey = sha1(trimmedDeofuscationKey)

		return hasheddeofuscationKey
	}

	func sha1(_ key: String) -> Data!
	{
		let data = key.data(using: .utf8)!
		var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
		data.withUnsafeBytes {
			_ = CC_SHA1($0, CC_LONG(data.count), &digest)
		}
		let hexBytes = digest.map { String(format: "%02hhx", $0) }
		let hash = hexBytes.joined()

		guard hash.characters.count == 20 else {
			debugPrint("hash is not a 20 chars string.")
			return nil
		}

		let mask = hash.data(using: .utf8)

		return mask
	}
}
