import System
import Foundation

public extension String {
    func isIgnored(in ignore_file: String, bustCache: Bool = false) -> Bool {
        check_if_ignored(self, ignore_file, bustCache)
    }
    @available(macOS 12, *)
    func isIgnored(in ignore_file: FilePath, bustCache: Bool = false) -> Bool {
        check_if_ignored(self, ignore_file.string, bustCache)
    }
    func isIgnored(in ignore_file: URL, bustCache: Bool = false) -> Bool {
        check_if_ignored(self, ignore_file.path, bustCache)
    }
}

@available(macOS 12, *)
public extension FilePath {
    func isIgnored(in ignore_file: String, bustCache: Bool = false) -> Bool {
        check_if_ignored(string, ignore_file, bustCache)
    }
    func isIgnored(in ignore_file: FilePath, bustCache: Bool = false) -> Bool {
        check_if_ignored(string, ignore_file.string, bustCache)
    }
    func isIgnored(in ignore_file: URL, bustCache: Bool = false) -> Bool {
        check_if_ignored(string, ignore_file.path, bustCache)
    }
}

public extension URL {
    func isIgnored(in ignore_file: String, bustCache: Bool = false) -> Bool {
        check_if_ignored(path, ignore_file, bustCache)
    }
    @available(macOS 12, *)
    func isIgnored(in ignore_file: FilePath, bustCache: Bool = false) -> Bool {
        check_if_ignored(path, ignore_file.string, bustCache)
    }
    func isIgnored(in ignore_file: URL, bustCache: Bool = false) -> Bool {
        check_if_ignored(path, ignore_file.path, bustCache)
    }
}

public extension Sequence where Element == String {
    func checkIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Bool] {
        let joined = joined(separator: separator)
        let result = check_if_ignored_batch(joined, ignoreFile, separator, bustCache)
        return result.toString().split(separator: Character(separator), omittingEmptySubsequences: false).map { $0 == "1" }
    }

    func filterIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Element] {
        let elements = Array(self)
        let ignored = elements.checkIgnored(in: ignoreFile, separator: separator, bustCache: bustCache)
        return zip(elements, ignored).compactMap { $1 ? nil : $0 }
    }
}

public extension Sequence where Element == URL {
    func checkIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Bool] {
        let joined = map(\.path).joined(separator: separator)
        let result = check_if_ignored_batch(joined, ignoreFile, separator, bustCache)
        return result.toString().split(separator: Character(separator), omittingEmptySubsequences: false).map { $0 == "1" }
    }

    func filterIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Element] {
        let elements = Array(self)
        let ignored = elements.checkIgnored(in: ignoreFile, separator: separator, bustCache: bustCache)
        return zip(elements, ignored).compactMap { $1 ? nil : $0 }
    }
}

@available(macOS 12, *)
public extension Sequence where Element == FilePath {
    func checkIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Bool] {
        let joined = map(\.string).joined(separator: separator)
        let result = check_if_ignored_batch(joined, ignoreFile, separator, bustCache)
        return result.toString().split(separator: Character(separator), omittingEmptySubsequences: false).map { $0 == "1" }
    }

    func filterIgnored(in ignoreFile: String, separator: String = "\n", bustCache: Bool = false) -> [Element] {
        let elements = Array(self)
        let ignored = elements.checkIgnored(in: ignoreFile, separator: separator, bustCache: bustCache)
        return zip(elements, ignored).compactMap { $1 ? nil : $0 }
    }
}
