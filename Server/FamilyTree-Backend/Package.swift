import PackageDescription

let package = Package(
	name: "FamilyTree-Backend",
    targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
		.Package(url: "https://github.com/SwiftORM/MySQL-StORM.git", majorVersion: 1, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-MySQL.git", majorVersion: 1, minor: 0),
		.Package(url: "https://github.com/rymcol/SwiftSQL.git", majorVersion: 0),
		.Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)..<Version(3, .max, .max)),
		.Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 2, minor: 2),
		
//		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2),
//		.Package(url: "https://github.com/SwiftORM/MySQL-StORM.git", majorVersion: 1, minor: 0),
//		.Package(url: "https://github.com/PerfectlySoft/Perfect-Turnstile-MySQL.git", majorVersion: 1, minor: 0),
//		.Package(url: "https://github.com/rymcol/SwiftSQL.git", majorVersion: 0),
    ]
)
