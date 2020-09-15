//
//  Pointers.swift
//  SwiftGit2
//
//  Created by Matt Diephouse on 12/23/14.
//  Copyright (c) 2014 GitHub, Inc. All rights reserved.
//

import Clibgit2

/// A pointer to a git object.
public protocol PointerType: Hashable {
	/// The OID of the referenced object.
	var oid: OID { get }

	#if LIBGIT2V1
	/// The libgit2 `git_object_t` of the referenced object.
	var type: git_object_t { get }
	#else
	/// The libgit2 `git_otype` of the referenced object.
	var type: git_otype { get }
	#endif
}

public extension PointerType {
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.oid == rhs.oid
			&& lhs.type == rhs.type
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(oid)
	}
}

/// A pointer to a git object.
public enum Pointer: PointerType {
	case commit(OID)
	case tree(OID)
	case blob(OID)
	case tag(OID)

	public var oid: OID {
		switch self {
		case let .commit(oid):
			return oid
		case let .tree(oid):
			return oid
		case let .blob(oid):
			return oid
		case let .tag(oid):
			return oid
		}
	}

	#if LIBGIT2V1
	public var type: git_object_t {
		switch self {
		case .commit:
			return GIT_OBJECT_COMMIT
		case .tree:
			return GIT_OBJECT_TREE
		case .blob:
			return GIT_OBJECT_BLOB
		case .tag:
			return GIT_OBJECT_TAG
		}
	}

	/// Create an instance with an OID and a libgit2 `git_object_t`.
	init?(oid: OID, type: git_object_t) {
		switch type {
		case GIT_OBJECT_COMMIT:
			self = .commit(oid)
		case GIT_OBJECT_TREE:
			self = .tree(oid)
		case GIT_OBJECT_BLOB:
			self = .blob(oid)
		case GIT_OBJECT_TAG:
			self = .tag(oid)
		default:
			return nil
		}
	}
	#else
	public var type: git_otype {
		switch self {
		case .commit:
			return GIT_OBJ_COMMIT
		case .tree:
			return GIT_OBJ_TREE
		case .blob:
			return GIT_OBJ_BLOB
		case .tag:
			return GIT_OBJ_TAG
		}
	}

	/// Create an instance with an OID and a libgit2 `git_otype`.
	init?(oid: OID, type: git_otype) {
		switch type {
		case GIT_OBJ_COMMIT:
			self = .commit(oid)
		case GIT_OBJ_TREE:
			self = .tree(oid)
		case GIT_OBJ_BLOB:
			self = .blob(oid)
		case GIT_OBJ_TAG:
			self = .tag(oid)
		default:
			return nil
		}
	}
	#endif
}

extension Pointer: CustomStringConvertible {
	public var description: String {
		switch self {
		case .commit:
			return "commit(\(oid))"
		case .tree:
			return "tree(\(oid))"
		case .blob:
			return "blob(\(oid))"
		case .tag:
			return "tag(\(oid))"
		}
	}
}

public struct PointerTo<T: ObjectType>: PointerType {
	public let oid: OID

	#if LIBGIT2V1
	public var type: git_object_t {
		return T.type
	}
	#else
	public var type: git_otype {
		return T.type
	}
	#endif

	public init(_ oid: OID) {
		self.oid = oid
	}
}
