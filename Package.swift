// swift-tools-version:5.7.1
import PackageDescription

let package = Package(
  name: "awsbuddy",
  platforms: [
    .macOS(.v11)
  ],
  targets: [
    .executableTarget(
      name: "awsbuddy",
      path: "awsbuddy")
  ]
)
