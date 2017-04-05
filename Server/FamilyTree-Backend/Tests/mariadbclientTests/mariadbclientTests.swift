#if os(Linux)
	import SwiftGlibc
#else
	import Darwin
#endif

import XCTest
@testable import mariadbclient

class mariadbclientTests: XCTestCase {
    func testExample() {
      var ptr: UnsafeMutablePointer<MYSQL>?
      ptr = mysql_init(nil)
      XCTAssertNotEqual(ptr, nil)
			// please change to your mariadb config to test the connection.
      let check = mysql_real_connect(ptr!, "127.0.0.1", "root", "123", "test", 3306, "/var/run/mysqld/mysqld.sock", 0)
      XCTAssertEqual(check, ptr)
    }


    static var allTests : [(String, (mariadbclientTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
