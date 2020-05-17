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

public struct CoinsReponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: [Coin]
}

public struct Coin: Decodable {
    public let name: String
    public let symbol: String
    public let isActive: Bool
    public let isFiat: Bool
    public let logoUrl: String
    public let parentCode: String?
    public let addressAdditionalData: String?
}

public struct RateResponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: Rate
    public let msg: String
}

public struct BulkRateResponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: [BulkRate]
    public let msg: String
}

public struct BulkRate: Decodable {
    public let depositCoin: String
    public let destinationCoin: String
    public let rate: Double
    public let minerFee: Double
    public let limitMinDepositCoin: Double
    public let limitMaxDepositCoin: Double
    public let limitMinDestinationCoin: Double
    public let limitMaxDestinationCoin: Double
}

public struct Rate: Decodable {
    public let rate: Double
    public let minerFee: Double
    public let limitMinDepositCoin: Double
    public let limitMaxDepositCoin: Double
    public let limitMinDestinationCoin: Double
    public let limitMaxDestinationCoin: Double
    public let depositCoinAmount: Double
}

public struct Address: Codable {
    public let address: String
    public let tag: String?
    
    public init(address: String, tag: String?) {
        self.address = address
        self.tag = tag
    }
}

public struct Order {
    public let depositCoin: String
    public let destinationCoin: String
    public let depositCoinAmount: Float?
    public let destinationCoinAmount: Float?
    public let destinationAddress: Address
    public let refundAddress: Address
    public let callbackUrl: String?
    
    public init(
    depositCoin: String,
    destinationCoin: String,
    depositCoinAmount: Float?,
    destinationCoinAmount: Float?,
    destinationAddress: Address,
    refundAddress: Address,
    callbackUrl: String?
    ) {
        self.depositCoin = depositCoin
        self.destinationCoin = destinationCoin
        self.depositCoinAmount = depositCoinAmount
        self.destinationCoinAmount = destinationCoinAmount
        self.destinationAddress = destinationAddress
        self.refundAddress = refundAddress
        self.callbackUrl = callbackUrl
    }
}

extension Order: Encodable {}

public struct CoinOrderDetailResponse: Decodable {
    public let orderId: String
    public let exchangeAddress: Address
    public let expectedDepositCoinAmount: Double
    public let expectedDestinationCoinAmount: Double
}

public struct OrderResponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: CoinOrderDetailResponse
    public let msg: String
}

public struct OrderStatusResponse: Decodable {
    public let success: Bool
    public let code: String
    public let data: OrderStatusDetailResponse
    public let msg: String
}

public struct OrdersDetailsResponse: Decodable {
    public let count: Int
    public let items: [OrderStatusDetailResponse]
    public let totalCount: Int
    public let isPrev: Bool
    public let isNext: Bool
}

public struct OrdersReponse: Decodable {
    public let success: Bool
    public let code: String
    public let msg: String
    public let data: OrdersDetailsResponse
}

public struct OrderStatusDetailResponse: Decodable {
    public let orderId: String
    public let exchangeAddress: Address
    public let destinationAddress: Address
    public let createdAt: Int
    public let status: String
    public let inputTransactionHash: String?
    public let outputTransactionHash: String?
    public let depositCoin: String
    public let destinationCoin: String
    public let depositCoinAmount: Double?
    public let destinationCoinAmount: Double?
    public let validTill: Int
    public let userReferenceId: String?
    public let expectedDepositCoinAmount: Double
    public let expectedDestinationCoinAmount: Double
    public let clientFee: Double?
    public let callbackUrl: String?
    
    public var validTillDate: Date? {
        guard let timeInterval = TimeInterval("\(validTill)".prefix(10)) else {
            return nil
        }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
