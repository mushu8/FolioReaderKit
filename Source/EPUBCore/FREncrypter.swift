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

enum FREncryptionMethod: String
{
	case obfuscate="http://www.idpf.org/2008/embedding"
}

class FREncrypter: NSObject {
	
	/// Singleton instance
	open static let shared = FREncrypter()
	fileprivate override init() {}

	///
	func decrypt(atPath: String, withMethod encryptionMethod: FREncryptionMethod!, andKey key: String)
	{
		debugPrint("decryption of item at path : \(atPath) with method : \(encryptionMethod)")

		guard !atPath.isEmpty else { return }

		switch encryptionMethod
		{
		case encryptionMethod:
			do {
				try obfuscate(contentsOfFile: atPath, withEpubUID: key)
			}
			catch {
				debugPrint("error caught : \(error)")
			}
		default:
			debugPrint("encryption method not supported yet.")
		}
	}

	fileprivate func obfuscate(contentsOfFile path: String, withEpubUID epubUID: String) throws
	{
		var len = 0
		let fileData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)

		let mask = makeObfuscationKey(epubUID: epubUID)

		var buffer		= [UInt8](repeating: 0, count: 4096)
		var first		= true
		let inputStream = InputStream(data: fileData)
		let outpuStream = OutputStream(toFileAtPath: path, append: false)!

		inputStream.open()
		outpuStream.open()

		repeat
		{
			len = inputStream.read(&buffer, maxLength: buffer.count)

			if(len > 0)
			{
				// the algorithm is applied for the first 1040 bytes only
				if (first)
				{
					first = false
					for index in 0...1040
					{
						buffer[index] = buffer[index] ^ mask[index % mask.count]
					}
				}
			}
			else if len < 0
			{
				// it means inputStream.read return an -1 error code
				debugPrint("error : \(inputStream.streamError)")
				inputStream.close()
				outpuStream.close()
				return
			}
			else
			{
				// just copy the bytes as they are
			}

			outpuStream.write(buffer, maxLength: len)
		}
			while len > 0

	}

	func makeObfuscationKey(epubUID: String) -> Data
	{
		let trimmedUID		= epubUID.trimmingCharacters(in: .whitespaces)
		let keyData			= trimmedUID.data(using: .utf8)!
		let hashedKeyData	= keyData.SHA1!

		return hashedKeyData
	}
}

extension Data {

	func hexEncodedString() -> String
	{
		return map { String(format: "%02hhx", $0) }.joined()
	}

	var SHA1: Data! {
		var result = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
		_ = result.withUnsafeMutableBytes {resultPtr in
			self.withUnsafeBytes {(bytes: UnsafePointer<UInt8>) in
				CC_SHA1(bytes, CC_LONG(count), resultPtr)
			}
		}

		guard result.count == 20 else {
			debugPrint("hashed key size is not 20")
			return nil
		}

		return result
	}
}
