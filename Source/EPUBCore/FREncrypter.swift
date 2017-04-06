//
//  FREncrypter.swift
//  FolioReaderKit
//
//  Created by Alexandre Sagette on 06/04/2017.
//  Copyright © 2017 FolioReader. All rights reserved.
//

import Foundation

class FREncrypter: NSObject
{
	/// Singleton instance
	open static let shared = FREncrypter()
	fileprivate override init() {}

	///
	func deobfuscate(path atPath: String, method withMethod: String)
	{
		debugPrint("deobfuscation of item at path : \(atPath)\n\twith method : \(withMethod)")
	}
}
