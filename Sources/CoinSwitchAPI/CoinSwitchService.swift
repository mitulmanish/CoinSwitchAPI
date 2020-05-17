import RxSwift
import Foundation

struct CoinSwitchService {
    
    private let configuration: Configuration
    private let host: String
    private let version: Version
    private let apiType: APIType
    
    init(
        configuration: Configuration,
        host: String,
        version: Version,
        apiType: APIType
    ) {
        self.configuration = configuration
        self.host = host
        self.version = version
        self.apiType = apiType
    }
    
    private func url(endPoint: Endpoint) -> Observable<URL> {
        guard var url = URL(string: host) else {
            return Observable.error(NetworkingError.invalidURL)
        }
        [version.description,
        apiType.description,
        endPoint.description
        ]
        .filter { $0.isEmpty == false }
        .forEach { url.appendPathComponent($0) }
        return Observable.of(url)
    }
    
    private func request(
        endpoint: Endpoint,
        method: HTTPMethod,
        params: [String: String]
    ) -> Observable<URLRequest> {
        url(endPoint: endpoint)
        .map { [configuration] in
            var request = URLRequest(url: $0)
            request.httpMethod = method.description
            configuration.toDictionary.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            guard var urlComponents = URLComponents(
                url: $0,
                resolvingAgainstBaseURL: true
            ) else {
                throw NetworkingError.invalidURL
            }
            urlComponents.queryItems = params.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            guard let finalURL = urlComponents.url else {
                throw NetworkingError.invalidURL
            }
            request.url = finalURL
            return request
        }
    }
    
    private func request<U: Encodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        body: U
    ) -> Observable<URLRequest> {
        url(endPoint: endpoint)
        .map { [configuration] in
            var request = URLRequest(url: $0)
            request.httpMethod = method.description
            configuration.toDictionary.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            switch method {
            case .post:
                do {
                    request.httpBody = try JSONEncoder().encode(body)
                } catch let error {
                    throw error
                }
            default:
                break
            }
            return request
        }
    }
    
    func object<T: Decodable, U: Encodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        body: U
    ) -> Observable<T> {
        data(endPoint: endpoint, method: method, body: body)
        .flatMap { self.toObject(data: $0) }
    }
    
    func object<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        params: [String: String] = [:]
    ) -> Observable<T> {
        data(endPoint: endpoint, method: method, params: params)
        .flatMap { self.toObject(data: $0) }
    }
    
    private func data<U: Encodable>(
        endPoint: Endpoint,
        method: HTTPMethod,
        body: U
    ) -> Observable<Data> {
        request(endpoint: endPoint, method: method, body: body)
        .flatMap { $0.rx.data() }
        .flatMap { self.sanitizeResponse(response: $0, data: $1) }
    }
    
    private func data(
        endPoint: Endpoint,
        method: HTTPMethod,
        params: [String: String]
    ) -> Observable<Data> {
        request(endpoint: endPoint, method: method, params: params)
        .flatMap { $0.rx.data() }
        .flatMap { self.sanitizeResponse(response: $0, data: $1) }
    }
    
    private func toObject<T: Decodable>(data: Data) -> Observable<T> {
        do {
            return Observable.of(try JSONDecoder().decode(T.self, from: data))
        } catch let error {
            return Observable.error(error)
        }
    }
    
    private func sanitizeResponse(
        response: HTTPURLResponse,
        data: Data
    ) -> Observable<Data> {
        guard let error = NetworkingError.from(httpCode: response.statusCode) else {
            return Observable.of(data)
        }
        return Observable.error(error)
    }
}

extension URLRequest: ReactiveCompatible {}

private extension Reactive where Base == URLRequest {
    func data() -> Observable<(HTTPURLResponse, Data)> {
        Observable.create { observer in
            let task = URLSession.shared.dataTask(with: self.base) {
                data, respose, error in
                if let error = error {
                    observer.onError(error)
                    observer.onCompleted()
                    return
                }
                guard let response = respose as? HTTPURLResponse else {
                    observer.onError(NetworkingError.noResponse)
                    observer.onCompleted()
                    return
                }
                guard let data = data else {
                    observer.onError(NetworkingError.dataNotFound)
                    observer.onCompleted()
                    return
                }
                observer.onNext((response, data))
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
