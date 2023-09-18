import System
import Foundation

public extension String {
    func isIgnored(in ignore_file: String) -> Bool {
        check_if_ignored(self, ignore_file)
    }
    @available(macOS 12, *)
    func isIgnored(in ignore_file: FilePath) -> Bool {
        check_if_ignored(self, ignore_file.string)
    }
    func isIgnored(in ignore_file: URL) -> Bool {
        check_if_ignored(self, ignore_file.path)
    }
}

@available(macOS 12, *)
public extension FilePath {
    func isIgnored(in ignore_file: String) -> Bool {
        check_if_ignored(string, ignore_file)
    }
    func isIgnored(in ignore_file: FilePath) -> Bool {
        check_if_ignored(string, ignore_file.string)
    }
    func isIgnored(in ignore_file: URL) -> Bool {
        check_if_ignored(string, ignore_file.path)
    }
}

public extension URL {
    func isIgnored(in ignore_file: String) -> Bool {
        check_if_ignored(path, ignore_file)
    }
    @available(macOS 12, *)
    func isIgnored(in ignore_file: FilePath) -> Bool {
        check_if_ignored(path, ignore_file.string)
    }
    func isIgnored(in ignore_file: URL) -> Bool {
        check_if_ignored(path, ignore_file.path)
    }
}
