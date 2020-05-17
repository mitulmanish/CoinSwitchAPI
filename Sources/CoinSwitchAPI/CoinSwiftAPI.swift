import RxSwift

public protocol CoinSwitchAPIInterface: AnyObject {
    func coins() -> Observable<CoinsReponse>
    func pair<Body: Encodable>(body: Body) -> Observable<PairResponse>
    func rate<Body: Encodable>(body: Body) -> Observable<RateResponse>
    func order<Body: Encodable>(body: Body) -> Observable<OrderResponse>
    func orderDetail(orderID: String) -> Observable<OrderStatusResponse>
    func orders(start: Int, count: Int) -> Observable<OrdersReponse>
    func bulkRate<Body: Encodable>(body: Body) -> Observable<BulkRateResponse>
}

public class CoinSwitchAPI: CoinSwitchAPIInterface {
    
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
