public func check_if_ignored<GenericToRustStr: ToRustStr>(_ path: GenericToRustStr, _ ignore_file: GenericToRustStr) -> Bool {
    return ignore_file.toRustStr({ ignore_fileAsRustStr in
        return path.toRustStr({ pathAsRustStr in
        __swift_bridge__$check_if_ignored(pathAsRustStr, ignore_fileAsRustStr)
    })
    })
}


