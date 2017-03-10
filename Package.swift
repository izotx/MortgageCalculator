import PackageDescription

let package = Package(
    name: "MortgageServerSide",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine", majorVersion: 1),
    ]
)
