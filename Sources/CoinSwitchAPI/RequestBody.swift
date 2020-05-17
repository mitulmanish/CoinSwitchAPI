import Foundation

public struct PairBody {
    public let depositCoin: String
    public let destinationCoin: String
    
    public init(depositCoin: String, destinationCoin: String) {
        self.depositCoin = depositCoin
        self.destinationCoin = destinationCoin
    }
}

extension PairBody: Encodable {}

public struct RateBody {
    public let depositCoin: String
    public let destinationCoin: String
    public let depositCoinAmount: Double
    
    public init(
        depositCoin: String,
        destinationCoin: String,
        depositCoinAmount: Double
    ) {
        self.depositCoin = depositCoin
        self.destinationCoin = destinationCoin
        self.depositCoinAmount = depositCoinAmount
    }
}

extension RateBody: Encodable {}

public struct Pair: Decodable {
    
    public let depositCoin: String
    public let destinationCoin: String
    public let isActive: Bool
    
    init(
        depositCoin: String,
        destinationCoin: String,
        isActive: Bool
    ) {
        self.depositCoin = depositCoin
        self.destinationCoin = destinationCoin
        self.isActive = isActive
    }
}

public struct DepositCoinContainer {
    
    public let depositCoin: String
    
    public init(depositCoin: String) {
        self.depositCoin = depositCoin
    }
}

extension DepositCoinContainer: Encodable {}

public struct PairResponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: [Pair]
}
