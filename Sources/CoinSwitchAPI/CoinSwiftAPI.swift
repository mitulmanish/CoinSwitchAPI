import RxSwift

public struct CoinSwitchAPI {
    
    private let service: CoinSwitchService
    
    public init(
        configuration: Configuration,
        host: String,
        version: Version,
        apiType: APIType
    ) {
        service = CoinSwitchService(
            configuration: configuration,
            host: host,
            version: version,
            apiType: apiType
        )
    }
    
    public func coins() -> Observable<CoinsReponse> {
        service.object(endpoint: .coins, method: .get)
    }
    
    public func pair<Body: Encodable>(body: Body) -> Observable<PairResponse> {
        service.object(endpoint: .pairs, method: .post, body: body)
    }
    
    public func rate<Body: Encodable>(body: Body) -> Observable<RateResponse> {
        service.object(endpoint: .rate, method: .post, body: body)
    }
    
    public func order<Body: Encodable>(body: Body) -> Observable<OrderResponse> {
        service.object(endpoint: .order, method: .post, body: body)
    }
    
    public func orderDetail(orderID: String) -> Observable<OrderStatusResponse> {
        service.object(endpoint: .orderDetails(id: orderID), method: .get)
    }
    
    public func orders(start: Int, count: Int) -> Observable<OrdersReponse> {
        let params = ["start": "\(start)", "count": "\(count)"]
        return service.object(endpoint: .orders, method: .get, params: params)
    }
    
    public func bulkRate<Body: Encodable>(body: Body) -> Observable<BulkRateResponse> {
        service.object(endpoint: .bulkRate, method: .post, body: body)
    }
}

enum NetworkingError: Error {
    case invalidURL
    case noResponse
    case invalidCredentials
    case clientError
    case serverError
    case dataNotFound
    case unknown
    
    static func from(httpCode: Int) -> NetworkingError? {
        switch httpCode {
        case 200...399:
            return .none
        case 400, 401:
            return .invalidCredentials
        case 402...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknown
        }
    }
}

public struct Configuration {
    
    public let apiKey: String
    public let userIP: String
    
    public init(
        apiKey: String,
        userIP: String
    ) {
        self.apiKey = apiKey
        self.userIP = userIP
    }
    
    var toDictionary: [String: String] {
        [
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "x-user-ip": userIP
        ]
    }
}

public enum Version: String, CustomStringConvertible {
    case v2
    
    public var description: String {
         rawValue
    }
}

public enum APIType: String, CustomStringConvertible {
    case `dynamic`
    case fixed
    
    public var description: String {
        switch self {
        case .dynamic:
            return ""
        case .fixed:
            return rawValue
        }
    }
}

public enum HTTPMethod: String, CustomStringConvertible {
    
    case get
    case post
    
    public var description: String {
        rawValue.capitalized
    }
}

enum Endpoint: CustomStringConvertible {
    
    case coins
    case pairs
    case rate
    case order
    case orderDetails(id: String)
    case orders
    case bulkRate
    
    var description: String {
        switch self {
        case .coins:
            return "/coins"
        case .pairs:
            return "/pairs"
        case .rate:
            return "/rate"
        case .order:
            return "/order"
        case let .orderDetails(id):
            return "order/\(id)"
        case .orders:
            return "orders"
        case .bulkRate:
            return "/bulk-rate"
        }
    }
}
